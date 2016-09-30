From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/9] Do not use
 IBV_CMD_(REG_MR|RESIZE_CQ)_HAS_RESP_PARAMS
Date: Fri, 30 Sep 2016 13:07:14 +0000
Message-ID: <1475240830.18752.4.camel@intel.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1475182076-5411-5-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-5-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <D9EEFCF91855B14DBF6BE889F134535B-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "intel-opa-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <intel-opa-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE2LTA5LTI5IGF0IDE0OjQ3IC0wNjAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IFRoZXNlIHdlcmUgdXNlZCB0byBzdXBwb3J0IGJ1aWxkaW5nIHByb3ZpZGVyIHBsdWdpbnMg
YWdhaW5zdCBvbGQNCj4gdmVyc2lvbnMgb2YgbGliaWJ2ZXJicy4gU2luY2UgbGliaWJ2ZXJicyBp
cyBub3cgaW5jbHVkZWQgdG9nZXRoZXINCj4gd2l0aCB0aGUgcHJvdmlkZXIgdGhhdCBpcyBubyBs
b25nZXIgcG9zc2libGUgb3Igc3VwcG9ydGVkLg0KPiANCj4gVGhlIGRlZmluZSBpcyBrZXB0IGFz
IGl0IGlzIGluIGEgcHVibGljIGhlYWRlci4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEphc29uIEd1
bnRob3JwZSA8amd1bnRob3JwZUBvYnNpZGlhbnJlc2VhcmNoLmNvbT4NCj4gLS0tDQo+IMKgbGli
aGZpMXZlcmJzL3NyYy92ZXJicy5jwqDCoMKgwqB8IDE1ICsrKy0tLS0tLS0tLS0tLQ0KPiDCoGxp
Ymk0MGl3L3NyYy9pNDBpd191dmVyYnMuYyB8IDI2IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
DQo+IMKgbGliaXBhdGh2ZXJicy9zcmMvdmVyYnMuY8KgwqDCoHwgMTYgKysrLS0tLS0tLS0tLS0t
LQ0KPiDCoGxpYm1seDUvc3JjL3ZlcmJzLmPCoMKgwqDCoMKgwqDCoMKgwqB8IDE4ICsrKystLS0t
LS0tLS0tLS0tLQ0KPiDCoGxpYm10aGNhL3NyYy92ZXJicy5jwqDCoMKgwqDCoMKgwqDCoHwgMjYg
KysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gwqBsaWJuZXMvc3JjL25lc191dmVyYnMuY8Kg
wqDCoMKgwqB8IDM1IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+IMKgbGli
cnhlL3NyYy9yeGUuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHwgMTYgKysrLS0tLS0tLS0tLS0t
LQ0KPiDCoDcgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMTMzIGRlbGV0aW9ucygt
KQ0KDQpGb3IgbGliaGZpMXZlcmJzIGFuZCBsaWJpcGF0aHZlcmJzOg0KDQpBY2tlZC1ieTogRGVu
bmlzIERhbGVzc2FuZHJvIDxkZW5uaXMuZGFsZXNzYW5kcm9AaW50ZWwuY29tPg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
