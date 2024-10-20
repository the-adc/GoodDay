const float4x4 projmat : register(c0);
const float4x4 rotmat : register(c4);
const float3 viewdata : register(c8);
const float3 vel : register(c9);
const float3 avel : register(c10);
const float blur : register(c11);

struct V_IN
{
	float4 pos : POSITION0;
	float3 norm : NORMAL0;
};

struct V_OUT
{
	float4 pos : POSITION0;
	float3 norm : TEXCOORD0;
	float3 viewdir : TEXCOORD1;
};

V_OUT color(V_IN In)
{
	V_OUT Out;

	Out.pos = mul(In.pos, rotmat);
	Out.norm = mul(In.norm, rotmat);
	Out.viewdir = (float3)(Out.pos) - viewdata;
	Out.pos = mul(Out.pos, projmat);

	return Out;
}

V_OUT velocity(V_IN In)
{
	V_OUT Out;

	Out.pos = mul(In.pos, rotmat);
	Out.norm = mul(In.norm, rotmat);
	Out.viewdir = vel + cross(avel, (float3)(Out.pos)) * 2.0;
	Out.pos.xyz += dot(Out.norm, Out.viewdir) * normalize(Out.viewdir) * blur;
	Out.viewdir = mul(Out.viewdir, projmat);
	Out.pos = mul(Out.pos, projmat);

	return Out;
}
