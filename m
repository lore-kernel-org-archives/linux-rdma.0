From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 6/6] RDMA/core: Unify style of IOCTL
 commands
Date: Thu, 1 Sep 2016 17:02:30 +0000
Message-ID: <1472749347.16467.22.camel@intel.com>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
                 <1471987907-6336-7-git-send-email-leon@kernel.org>
                 <1472738739.16467.8.camel@intel.com>
         <20160901164624.GC6479@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160901164624.GC6479-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <C8FDF65894DF5241BEE1B85FCDE22627-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVGh1LCAyMDE2LTA5LTAxIGF0IDEwOjQ2IC0wNjAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFRodSwgU2VwIDAxLCAyMDE2IGF0IDAyOjA1OjQ0UE0gKzAwMDAsIERhbGVzc2FuZHJv
LCBEZW5uaXMgd3JvdGU6DQo+IA0KPiA+ID4gKy8qIGFsbG9jYXRlIEhGSSBhbmQgY29udGV4dCAq
Lw0KPiA+ID4gKyNkZWZpbmUgSEZJMV9DTURfQVNTSUdOX0NUWFTCoMKgwqDCoMKgKEhGSTFfQ01E
X0JBU0UgKyAweDAxKQ0KPiA+IA0KPiA+IFRoaXMgaXMgYSBtaW5vciBpc3N1ZSwgYnV0IHRoZSBw
cm9ibGVtIGhlcmUgaXMgd2hlbiB3ZSBidWlsZCBQU00NCj4gPiBhZ2FpbnN0IHRoaXMga2VybmVs
IGl0IHdpbGwgbm8gbG9uZ2VyIHdvcmsgZm9yIG9sZGVyIGtlcm5lbHMNCj4gPiBiZWNhdXNlDQo+
ID4gdGhlIHZhbHVlIG9mIEhGSTFfQ01EX0FTU0lHTl9DVFhUIGhhcyBjaGFuZ2VkIHdoZXJlIGFz
IGl0IHVzZWQgdG8NCj4gPiBiZSAxLg0KPiA+IFJpZ2h0IG5vdyBQU00gaXMgYmFja3dhcmRzIGNv
bXBhdGlibGUsIHRoaXMgYnJlYWtzIHRoYXQNCj4gPiBjb21wYXRpYmlsaXR5Lg0KPiANCj4gV2hh
dD8gU29tZW9uZSByZW51bWJlcmQgYW4gaW9jdGw/IFdoZW4/IFdoeT8gSG93Pw0KDQpObyBpb2N0
bCBudW1iZXIgd2FzIHN0aWxsIHRoZSBzYW1lLiBJdCdzIHRoZSB0aGluZyB0aGF0IGlzIHVzZWQg
dG8NCmRlZmluZSB0aGUgaW9jdGwgbnVtYmVyLg0KDQpUaGUgaW9jdGwgd2FzIG9yaWdpbmFsbHkg
ZGVmaW5lZCBhczoNCl9JT1dSKFJETUFfSU9DVExfTUFHSUMsIF9fTlVNKEFTU0lHTl9DVFhUKSwg
c3RydWN0IGhmaTFfdXNlcl9pbmZvKQ0KDQpXaGVyZSBfX05VTShBU1NJR05fQ1RYVCkgPSBIRkkx
X0NNRF9BU1NJR05fQ1RYVCArIDB4RTAgPSAxICsgMHhFMA0KDQpJdCB3YXMgY2hhbmdlZCB0byBi
ZToNCg0KX0lPV1IoUkRNQV9JT0NUTF9NQUdJQywgSEZJMV9DTURfQVNTSUdOX0NUWFQsIHN0cnVj
dCBoZmkxX3VzZXJfaW5mbykNCg0KV2hlcmUgSEZJMV9DTURfQVNTSUdOX0NUWFQgPSAweEUxLg0K
DQpTbyB0aGUgaW9jdGwgbnVtYmVyIGRvZW5zJ3QgY2hhbmdlLiBUaGUgdmFsdWUgb2YgSEZJMV9D
TURfQVNTSUdOX0NUWFQNCmRvZXMsIGl0IHdhcyAxIG5vdyBpdCBpcyAweEUxLiBIRkkxX0NNRF9B
U1NJR05fQ1RYVCBpcyB1c2VkIGJ5DQp1c2Vyc3BhY2UuDQoNCi1EZW5ueQ0KDQo=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
