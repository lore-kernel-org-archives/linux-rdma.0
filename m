From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH][next] net/mlx5e: Remove redundant assignment
Date: Sat, 9 Mar 2019 00:27:31 +0000
Message-ID: <7315f2cf88be6af599d5adb46e3768178e9b581b.camel@mellanox.com>
References: <da1f1300-20f4-2929-078b-71ac1772a933@mellanox.com>
         <20190304062645.GZ15253@mtr-leonro.mtl.com>
         <176546c027a13f39c0dd8d5915b2d16b98637782.camel@mellanox.com>
         <20190305.190323.1175144356168830240.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190305.190323.1175144356168830240.davem@davemloft.net>
Content-Language: en-US
Content-ID: <3DFDFCF76ABAAD4F931B881A62DB37F9@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: "davem@davemloft.net" <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "gustavo@embeddedor.com" <gustavo@embeddedor.com>, Roi Dayan <roid@mellanox.com>, "leon@kernel.org" <leon@kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Eli Britstein <elibr@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE5LTAzLTA1IGF0IDE5OjAzIC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBUdWUs
IDUgTWFyIDIwMTkgMjI6MjE6MzkgKzAwMDANCj4gDQo+ID4gT24gTW9uLCAyMDE5LTAzLTA0IGF0
IDA4OjI2ICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6DQo+ID4gPiBPbiBTdW4sIE1hciAw
MywgMjAxOSBhdCAwMzoyMDo1N1BNICswMDAwLCBSb2kgRGF5YW4gd3JvdGU6DQo+ID4gPiA+IE9u
IDAyLzAzLzIwMTkgMjE6MzksIEd1c3Rhdm8gQS4gUi4gU2lsdmEgd3JvdGU6DQo+ID4gPiA+ID4g
UmVtb3ZlIHJlZHVuZGFudCBhc3NpZ25tZW50IHRvIHR1bl9lbnRyb3B5LT5lbmFibGVkLg0KPiA+
ID4gPiA+IA0KPiA+ID4gPiA+IEFkZGVzc2VzLUNvdmVyaXR5LUlEOiAxNDc3MzI4ICgiVW51c2Vk
IHZhbHVlIikNCj4gPiA+ID4gPiBGaXhlczogOTc0MTdmNjE4MmY4ICgibmV0L21seDVlOiBGaXgg
R1JFIGtleSBieSBjb250cm9sbGluZw0KPiA+ID4gPiA+IHBvcnQNCj4gPiA+ID4gPiB0dW5uZWwg
ZW50cm9weSBjYWxjdWxhdGlvbiIpDQo+ID4gPiA+IA0KPiA+ID4gPiB0aGUgY29tbWl0IGRvZXNu
J3QgZml4IGFueSByZWFsIGlzc3VlIGJ1dCBpcyBtb3JlIG9mIGEgY2xlYW51cC4NCj4gPiA+ID4g
c28gSSdtIG5vdCBzdXJlIGlmIGZpeGVzIGxpbmUgaXMgcmVsZXZhbnQgb3Igbm90Lg0KPiA+ID4g
PiBiZXNpZGUgdGhhdCBsb29rcyBvay4NCj4gPiA+IA0KPiA+ID4gSXQgZG9lc24ndCBtYXR0ZXIg
aWYgaXQgaXMgcmVhbCBpc3N1ZSBvciBub3QsIHRoZSBjb2RlIGlzIHdyb25nDQo+ID4gPiBhbmQN
Cj4gPiA+IHNob3VsZCBiZSBmaXhlZC4gVGhpcyBhbG9uZSBpcyBlbm91Z2ggdG8gc2VlIHRoZSBG
aXhlcyBsaW5lLg0KPiA+ID4gDQo+ID4gPiBUaGFua3MsDQo+ID4gPiBBY2tlZC1ieTogTGVvbiBS
b21hbm92c2t5IDxsZW9ucm9AbWVsbGFub3guY29tPg0KPiA+IA0KPiA+IEFja2VkLWJ5OiBTYWVl
ZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4gPiBEYXZlLCBEbyB5b3UgdGhpbmsg
c3VjaCBwYXRjaCBzaG91bGQgZ28gdG8gbmV0LCBvciBkbyB5b3Ugd2FudCBtZQ0KPiA+IHRvDQo+
ID4gc2VuZCBpdCBpbiBteSBuZXh0IHB1bGwgcmVxdWVzdCB0byBuZXQtbmV4dCwgb25jZSBpdCBp
cyBvcGVuIG9mDQo+ID4gY291cnNlDQo+ID4gPw0KPiANCj4gVGhpcyBmZWVscyBtb3JlIGxpa2Ug
bmV0LW5leHQgc3R1ZmYgdG8gbWUsIHRoYW5rcyBmb3IgYXNraW5nLg0KDQpBcHBsaWVkIHRvIG5l
dC1uZXh0LW1seDUsIHdpbGwgYmUgc2VudCBpbiB0aGUgbmV4dCBwdWxsIHJlcXVlc3Qgd2hlbg0K
bmV0LW5leHQgcmVvcGVucywgVGhhbmtzIQ0KDQo=
