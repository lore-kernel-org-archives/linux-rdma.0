From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] ib_srpt: use kvmalloc to allocate ring pointers
Date: Tue, 10 Jul 2018 15:08:38 +0000
Message-ID: <5196ea6e33825dd5fde58d23b38630afafcb77f1.camel@wdc.com>
References: <1531144268-25361-1-git-send-email-jan.dakinevich@virtuozzo.com>
         <20180710053944.GN3014@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180710053944.GN3014@mtr-leonro.mtl.com>
Content-Language: en-US
Content-ID: <5319023AC802C94C93A502B3B54131CA@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "leon@kernel.org" <leon@kernel.org>, "jan.dakinevich@virtuozzo.com" <jan.dakinevich@virtuozzo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "den@virtuozzo.com" <den@virtuozzo.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "khorenko@virtuozzo.com" <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCAyMDE4LTA3LTEwIGF0IDA4OjM5ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIE1vbiwgSnVsIDA5LCAyMDE4IGF0IDA0OjUxOjA4UE0gKzAzMDAsIEphbiBEYWtpbmV2
aWNoIHdyb3RlOg0KPiA+IEFuIGFycmF5IG9mIHBvaW50ZXJzIHRvIFNSUFQgY29udGV4dHMgaW4g
aWJfZGV2aWNlIGlzIG92ZXIgMzBLaUIgZXZlbg0KPiA+IGluIGRlZmF1bHQgY2FzZSwgaW4gd2hp
Y2ggYW4gYW1vdW50IG9mIGNvbnRleHRzIGlzIDQwOTUuIFRoZSBwYXRjaA0KPiA+IGlzIGludGVu
ZGVkIHRvIHdlZWQgb3V0IGxhcmdlIGNvbnRpZ291cyBhbGxvY2F0aW9uIGZvciBub24tRE1BIG1l
bW9yeS4NCj4gDQo+IGt2bWFsbG9jKiBkb2Vzbid0ICJ3ZWVkIG91dCIgbGFyZ2UgY29udGlndW91
cyBhbGxvY2F0aW9ucywgYnV0IHRyaWVzIHRvDQo+IGFsbG9jYXRlIHRoZW0gYW5kIGdyYWNlZnVs
bHkgZmFsbGJhY2sgdG8gdm1hbGxvYyBpZiBrbWFsbG9jIGZhaWxzLg0KPiANCj4gTW9yZSBvbiB0
aGF0LCBmb3IgYWxsb2NhdGlvbnMgbGVzcyB0aGFuIHBhZ2UgKDY0S0IgZm9yIFBvd2VyUEMpLCBp
dCB3aWxsDQo+IG5vdCBjYWxsIHRvIHZtYWxsb2MgYXQgYWxsLCB3aGljaCBpcyBmaW5lIHRvbywg
YmVjYXVzZSBwYWdlcyBncmFudWxhcml0eS4NCj4gDQo+IElmIHlvdSB3YW50IHRvIGdldCByaWQg
b2YgImNvbnRpZ3VvdXMgYWxsb2NhdGlvbnMiLCB1c2Ugdm1hbGxvYyBpbnN0ZWFkLg0KDQp2bWFs
bG9jKCkgaGFzIGEgdmVyeSBzaWduaWZpY2FudCBkaXNhZHZhbnRhZ2UgY29tcGFyZWQgdG8ga3Zt
YWxsb2MoKTogd2l0aA0Kdm1hbGxvYygpIGl0IGlzIGd1YXJhbnRlZWQgdGhhdCBtZW1vcnkgYWxs
b2NhdGlvbnMgd2lsbCBiZSBzbG93LiBUaGF0J3Mgbm90DQp0aGUgY2FzZSBmb3Iga3ZtYWxsb2Mo
KSBpZiB0aGUgbnVtYmVyIG9mIGJ5dGVzIHRoYXQgaXMgYWxsb2NhdGVkIGlzIHNtYWxsDQplbm91
Z2guDQoNCkJhcnQuDQoNCg0KDQoNCg==
