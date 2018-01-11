From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 2/7] RDMA/core: Add helper function to create
 named QPs
Date: Thu, 11 Jan 2018 19:50:21 +0000
Message-ID: <1515700219.2752.55.camel@wdc.com>
References: <20180111153132.11143-1-leon@kernel.org>
         <20180111153132.11143-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111153132.11143-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Content-ID: <F6F6801D4D83294DAD212B9E3BA009AC-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE4LTAxLTExIGF0IDE3OjMxICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IC0tLSBhL2luY2x1ZGUvcmRtYS9pYl92ZXJicy5oDQo+ICsrKyBiL2luY2x1ZGUvcmRtYS9p
Yl92ZXJicy5oDQo+IEBAIC0xMTQxLDYgKzExNDEsMTIgQEAgc3RydWN0IGliX3FwX2luaXRfYXR0
ciB7DQo+ICAgICAgICAgdTggICAgICAgICAgICAgICAgICAgICAgcG9ydF9udW07DQo+ICAgICAg
ICAgc3RydWN0IGliX3J3cV9pbmRfdGFibGUgKnJ3cV9pbmRfdGJsOw0KPiAgICAgICAgIHUzMiAg
ICAgICAgICAgICAgICAgICAgIHNvdXJjZV9xcG47DQo+ICsNCj4gKyAgICAgICAvKg0KPiArICAg
ICAgICAqIE5hbWUgb2YgZW50aXR5IHdoaWNoIGNyZWF0ZWQgdGhpcyBRUCwgZW1wdHkgc3RyaW5n
IG1lYW5zIHRoYXQNCj4gKyAgICAgICAgKiBpdCB3aWxsIGJlIHRha2VuIGF1dG9tYXRpY2FsbHkg
ZnJvbSB0YXNrX3N0cnVjdC4NCj4gKyAgICAgICAgKi8NCj4gKyAgICAgICBjaGFyIGNvbW1bVEFT
S19DT01NX0xFTl07DQo+ICB9Ow0KDQpXaHkgaXMgImNvbW0iIGEgY2hhciBhcnJheSBpbnN0ZWFk
IG9mIGEgY29uc3QgY2hhciBwb2ludGVyIG9yIGR5bmFtaWNhbGx5DQphbGxvY2F0ZWQgbWVtb3J5
IChrc3RyZHVwKCkpPyBDYW4gd2UgZ2V0IHJpZCBvZiB0aGUgc3RybmNweSgpIGNhbGxzIGluIGNv
ZGUNCnRoYXQgZmlsbHMgaW4gdGhpcyBkYXRhIHN0cnVjdHVyZT8NCg0KVGhhbmtzLA0KDQpCYXJ0
Lg0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
