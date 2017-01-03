From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Do not copy uninitialized data in
 ibv_cmd_modify_qp
Date: Tue, 3 Jan 2017 08:36:00 +0000
Message-ID: <1483432540.2911.3.camel@sandisk.com>
References: <20161222221334.GA15907@obsidianresearch.com>
         <1483344105.3592.1.camel@sandisk.com>
         <20170102211430.GC5544@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170102211430.GC5544-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <AD3A05E5918C344DA432B5C379AB952A-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uLCAyMDE3LTAxLTAyIGF0IDE0OjE0IC0wNzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IEkgZmVsdCB0aGF0IHBhc3NpbmcgdW5pbml0aWFsaXplZCBtZW1vcnkgaW50byB0aGUga2Vy
bmVsIHdhcyBqdXN0DQo+IGluIGdlbmVyYWwgYSBiYWQgaWRlYSwgYW5kIGFkZGluZyB0aGUgYnJh
bmNocyB0byBjb3B5IHplcm8gaW5zdGVhZCBvZg0KPiB1bi1pbml0IGlzIHByb2JhYmx5IHBlcmZv
cm1hbmNlIG5ldXRyYWwuDQo+IA0KPiBFdmVuIHNvLCBJIGRvbid0IHRoaW5rIHdlIGNhbiBmaXgg
dmFsZ3JpbmQsIGlvY3RsIGlzIGEgZGlmZmVyZW50IGNhc2UNCj4gYXMgaW9jdGxzIGFyZSBtdWNo
IG1vcmUgd2VsbCBkZWZpbmVkLCB0aGlzIGlzIHdyaXRlKCkgYW5kIHZhbGdyaW5kDQo+IHdvdWxk
IGhhdmUgdG8gZmlyc3Qga25vdyB3ZSBhcmUgd3JpdGluZyB0byBhIHV2ZXJicyBGRCB3aGljaCBz
ZWVtcw0KPiBjaGFsbGVuZ2luZyB0byBkZXRlcm1pbmUsIGNhbiB2YWxncmluZCBhbHJlYWR5IGRv
IHRoaXM/DQoNCkhlbGxvIEphc29uLA0KDQpBcyBmYXIgYXMgSSBrbm93IHRoZXJlIGlzIG5vdCB5
ZXQgYW55IGNvZGUgaW4gVmFsZ3JpbmQgdG8gaW50ZXJwcmV0IHRoZQ0KZGF0YSBzZW50IGZyb20g
dXNlciBzcGFjZSB0byBrZXJuZWwgdGhyb3VnaCB0aGUgd3JpdGUoKSBzeXN0ZW0gY2FsbC4gU2lu
Y2UNCkkgZG8gbm90IGtub3cgYW55IGFwcGxpY2F0aW9uIGZvciB3aGljaCBpYnZfbW9kaWZ5X3Fw
KCkgaXMgaW4gdGhlIGhvdCBwYXRoDQpJIHRoaW5rIG1vZGlmeWluZyB0aGUgaWJ2X21vZGlmeV9x
cCgpIGltcGxlbWVudGF0aW9uIGlzIGZpbmUuDQoNCkJhcnQu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
