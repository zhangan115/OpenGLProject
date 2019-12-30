precision mediump float;
varying vec2 TextCoord;
varying vec3 fragPos;
varying vec3 norm;

// 定义材质结构体
struct Material {
    sampler2D diffuse;
    sampler2D specular;
    float shininess;
};
uniform Material material;
// 定义光源结构体
struct Light {
    // vec3 position; // 使用定向光就不再需要了
    vec3 direction;
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

uniform Light light;
void main() {
    // 环境光照
    vec3 ambient = light.ambient* texture2D(material.diffuse, TextCoord).rgb;
    // 漫反射光照
    // 归一化光源线
    vec3 lightDir = normalize(-light.direction);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = diff * light.diffuse * texture2D(material.diffuse, TextCoord).rgb;

    // 镜面光照
    vec3 viewDir = normalize(-fragPos);
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    vec3 specular = spec * light.specular * texture2D(material.specular, TextCoord).rgb;

    // 结果
    vec3 result = ambient + diffuse + specular;

    gl_FragColor = vec4(result, 1.0);
}