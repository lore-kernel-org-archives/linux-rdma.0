From: Ajay Kaher <akaher@vmware.com>
Subject: Re: [PATCH v4 0/3] [v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Date: Tue, 25 Jun 2019 06:10:40 +0000
Message-ID: <0EA7BFD6-ABA6-4008-B30F-20653114F34F@vmware.com>
References: <1561410186-3919-1-git-send-email-akaher@vmware.com>
 <1561410186-3919-4-git-send-email-akaher@vmware.com>
 <20190624202150.GC3881@sasha-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190624202150.GC3881@sasha-vm>
Content-Language: en-US
Content-ID: <FAB09C25F4BC4C40B101E9C6E4EFD2C4@namprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>
Cc: "aarcange@redhat.com" <aarcange@redhat.com>, "jannh@google.com" <jannh@google.com>, "oleg@redhat.com" <oleg@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>, "rppt@linux.ibm.com" <rppt@linux.ibm.com>, "jgg@mellanox.com" <jgg@mellanox.com>, "mhocko@suse.com" <mhocko@suse.com>, "jglisse@redhat.com" <jglisse@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "riandrews@android.com" <riandrews@android.com>, "arve@android.com" <arve@android.com>, "yishaih@mellanox.com" <yishaih@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

DQrvu79PbiAyNS8wNi8xOSwgMTo1MSBBTSwgIlNhc2hhIExldmluIiA8c2FzaGFsQGtlcm5lbC5v
cmc+IHdyb3RlOg0KICAgIA0KPiBPbiBUdWUsIEp1biAyNSwgMjAxOSBhdCAwMjozMzowNkFNICsw
NTMwLCBBamF5IEthaGVyIHdyb3RlOg0KPiA+IGNvcmVkdW1wOiBmaXggcmFjZSBjb25kaXRpb24g
YmV0d2VlbiBtbWdldF9ub3RfemVybygpL2dldF90YXNrX21tKCkNCj4gPiBhbmQgY29yZSBkdW1w
aW5nDQo+ID4NCj4gPiBbUEFUQ0ggdjQgMS8zXToNCj4gPiBCYWNrcG9ydGluZyBvZiBjb21taXQg
MDRmNTg2NmU0MWZiNzA2OTBlMjgzOTc0ODdkOGJkOGVlYTdkNzEyYSB1cHN0cmVhbS4NCj4gPg0K
PiA+IFtQQVRDSCB2NCAyLzNdOg0KPiA+IEV4dGVuc2lvbiBvZiBjb21taXQgMDRmNTg2NmU0MWZi
IHRvIGZpeCB0aGUgcmFjZSBjb25kaXRpb24gYmV0d2Vlbg0KPiA+IGdldF90YXNrX21tKCkgYW5k
IGNvcmUgZHVtcGluZyBmb3IgSUItPm1seDQgYW5kIElCLT5tbHg1IGRyaXZlcnMuDQo+ID4NCj4g
PiBbUEFUQ0ggdjQgMy8zXQ0KPiA+IEJhY2twb3J0aW5nIG9mIGNvbW1pdCA1OWVhNmQwNmNmYTky
NDdiNTg2YTY5NWMyMWY5NGFmYTcxODNhZjc0IHVwc3RyZWFtLg0KPiA+DQo+ID4gW2RpZmYgZnJv
bSB2M106DQo+ID4gLSBhZGRlZCBbUEFUQ0ggdjQgMy8zXQ0KICAgICAgICANCj4gV2h5IGRvIGFs
bCB0aGUgcGF0Y2hlcyBoYXZlIHRoZSBzYW1lIHN1YmplY3QgbGluZT8NClRoYW5rcyBmb3IgY2F0
Y2hpbmcgdGhpcy4gSSB3aWxsIGNvcnJlY3QgaW4gbmV4dCB2ZXJzaW9uIG9mIHRoZXNlIHBhdGNo
ZXMsDQphbG9uZyB3aXRoIHJldmlldyBjb21tZW50cyBpZiBhbnkuDQogICAgDQogICAgICAgIA0K
PiBJIGd1ZXNzIGl0J3MgY29ycmVjdCBmb3IgdGhlIGZpcnN0IG9uZSwgYnV0IGNhbiB5b3UgZXhw
bGFpbiB3aGF0J3MgdXANCj4gd2l0aCAjMiBhbmQgIzM/DQo+DQo+IElmIHRoZSBzZWNvbmQgb25l
IGlzbid0IHVwc3RyZWFtLCBwbGVhc2UgZXhwbGFpbiBpbiBkZXRhaWwgd2h5IG5vdCBhbmQNCj4g
aG93IDQuOSBkaWZmZXJzIGZyb20gdXBzdHJlYW0gc28gdGhhdCBpdCByZXF1aXJlcyBhIGN1c3Rv
bSBiYWNrcG9ydC4NCg0KIzIgYXBwbGllZCB0byA0LjE0Lnk6DQpodHRwczovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUvc3RhYmxlLXF1ZXVlLmdpdC90cmVl
L3F1ZXVlLTQuMTQvaW5maW5pYmFuZC1maXgtcmFjZS1jb25kaXRpb24tYmV0d2Vlbi1pbmZpbmli
YW5kLW1seDQtbWx4NS1kcml2ZXItYW5kLWNvcmUtZHVtcGluZy5wYXRjaD9pZD1lNDA0MWEzZjZi
NTY5MTQwNTQ5ZmU3YjQxZWQ1MjdjNWMxZTM4ZWM5DQoNCkFuZCB0aGVuIHRvIDQuOS55IChzb21l
IHBhcnQgYXMgcmVxdWlyZXMpLiANCjQuMTggYW5kIG9ud2FyZHMgZG9lc24ndCBoYXZlICBtbWFw
X3NlbSBsb2NraW5nIGluIG1seDQgYW5kIG1seDUsIA0Kc28gbm8gbmVlZCBvZiAjMiBpbiA0LjE4
IGFuZCBvbndhcmRzLg0KDQo+IFRoZSB0aGlyZCBvbmUganVzdCBsb29rcyBsaWtlIGEgZGlmZmVy
ZW50IHBhdGNoIGFsdG9nZXRoZXIgd2l0aCBhIHdyb25nDQo+IHN1YmplY3QgbGluZT8NCiMzIHdh
cyBpbiBkaXNjdXNzaW9uIGhlcmUgKGR1cmluZyB2MSksIHNvIGFkZGVkIGhlcmUuIA0KICANCj4g
LS0NCj4gVGhhbmtzLA0KPiBTYXNoYQ0KIA0KDQo=
