From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: BUG: NULL pointer dereference at ib_uverbs_comp_handler+0x20
Date: Tue, 1 Aug 2017 12:32:57 -0600
Message-ID: <5866fa2e-d3d9-cdaf-bcb4-806f938aef83@deltatee.com>
References: <216b770e-fc08-68a6-c1bf-be96d52e325e@deltatee.com>
 <CAAKD3BDFcFDVvYYsimAqqWM9w-qv0Nc4U5Y54eGNhOATSkg0tA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------F3E860BB690A66CB1BD19BD1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BDFcFDVvYYsimAqqWM9w-qv0Nc4U5Y54eGNhOATSkg0tA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------F3E860BB690A66CB1BD19BD1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hey,

The patch Bharat provided fixes the kernel panic but RDMA in userspace
still does not work at all. Reverting the commits I mentioned still
fixes everything.

To answer your questions:

* I see the iwpm_register_pid message even when things are working so I
don't think it's related.

* All clients I've tried fail. I've attached a log of all the error
messages I see with various clients. (This was with Bharat's patch so
there was no kernel panic and I saw no dmesgs during these runs). The
same runs with the commits I mentioned reverted work fine.

* I retested everything with the CX4 cards as well and they have a
similar problem but produce different error messages. I've attached a
log of client runs as well. The CX4 also works once I revert those
patches. However, by memory, I don't think the CX4s ever suffered from
the kernel panic, and I guess it was just luck that the patches I
reverted caused all these problems.


On 01/08/17 05:08 AM, Matan Barak wrote:
> PS, e0fcc61113c isn't a bug fix, it's just a simple refactor.

If it's not a bug fix I don't think it should have a fixes tag. It
probably didn't mater in this case but you don't want refactor commits
to accidentally reach a stable kernel.

Thanks,

Logan







--------------F3E860BB690A66CB1BD19BD1
Content-Type: text/plain; charset=UTF-8;
 name="cxgb4-client-errors.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="cxgb4-client-errors.txt"

Z3VudGhvcnBAY2d5MS1kb25hcmQ6fiQgaWJfd3JpdGVfYncgLVIKCioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKgoqIFdhaXRpbmcgZm9yIGNsaWVudCB0byBjb25uZWN0
Li4uICoKKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiBDb3VsZG4ndCBj
cmVhdGUgcmRtYSBRUCAtIEludmFsaWQgYXJndW1lbnQKVW5hYmxlIHRvIGNyZWF0ZSBRUC4K
RmFpbGVkIHRvIGNyZWF0ZSBRUC4KIFVuYWJsZSB0byBjcmVhdGUgdGhlIHJlc291cmNlcyBu
ZWVkZWQgYnkgY29tbSBzdHJ1Y3QKIFVuYWJsZSB0byBwZXJmb3JtIHJkbWFfc2VydmVyIGZ1
bmN0aW9uCiBVbmFibGUgdG8gaW5pdCB0aGUgc29ja2V0IGNvbm5lY3Rpb24KZ3VudGhvcnBA
Y2d5MS1kb25hcmQ6fiQgaWJfd3JpdGVfYncgLVIgZmxhc2gtY3hnYgogQ291bGRuJ3QgY3Jl
YXRlIHJkbWEgUVAgLSBJbnZhbGlkIGFyZ3VtZW50ClVuYWJsZSB0byBjcmVhdGUgUVAuCkZh
aWxlZCB0byBjcmVhdGUgUVAuCiBVbmFibGUgdG8gY3JlYXRlIHRoZSByZXNvdXJjZXMgbmVl
ZGVkIGJ5IGNvbW0gc3RydWN0CiBVbmFibGUgdG8gcGVyZm9ybSByZG1hX2NsaWVudCBmdW5j
dGlvbgogVW5hYmxlIHRvIGluaXQgdGhlIHNvY2tldCBjb25uZWN0aW9uCmd1bnRob3JwQGNn
eTEtZG9uYXJkOn4kIHJwaW5nIC1zCnJkbWFfY3JlYXRlX3FwOiBJbnZhbGlkIGFyZ3VtZW50
CnNldHVwX3FwIGZhaWxlZDogLTEKZ3VudGhvcnBAY2d5MS1kb25hcmQ6fiQgcnBpbmcgLWMg
LWEgZmxhc2gtY3hnYiAtdiAtQzUKcmRtYV9jcmVhdGVfcXA6IEludmFsaWQgYXJndW1lbnQK
c2V0dXBfcXAgZmFpbGVkOiAtMQpndW50aG9ycEBjZ3kxLWRvbmFyZDp+JCB1Y21hdG9zZSAK
Y21hdG9zZTogc3RhcnRpbmcgc2VydmVyCmNtYXRvc2U6IHVuYWJsZSB0byBjcmVhdGUgUVA6
IEludmFsaWQgYXJndW1lbnQKY21hdG9zZTogZmFpbGluZyBjb25uZWN0aW9uIHJlcXVlc3QK
dGVzdCBjb21wbGV0ZQpyZXR1cm4gc3RhdHVzIC0xCmd1bnRob3JwQGNneTEtZG9uYXJkOn4k
IHVjbWF0b3NlIC1zIGZsYXNoLWN4Z2IKY21hdG9zZTogc3RhcnRpbmcgY2xpZW50CmNtYXRv
c2U6IGNvbm5lY3RpbmcKY21hdG9zZTogdW5hYmxlIHRvIGNyZWF0ZSBRUDogSW52YWxpZCBh
cmd1bWVudAp0ZXN0IGNvbXBsZXRlCnJldHVybiBzdGF0dXMgLTEKZ3VudGhvcnBAY2d5MS1k
b25hcmQ6fiQgaWJ2X3JjX3Bpbmdwb25nIAogIGxvY2FsIGFkZHJlc3M6ICBMSUQgMHgwMDAw
LCBRUE4gMHgwMDA0MzAsIFBTTiAweGVmOWY4ZSwgR0lEIDo6CkZhaWxlZCB0byBtb2RpZnkg
UVAgdG8gUlRSCkNvdWxkbid0IGNvbm5lY3QgdG8gcmVtb3RlIFFQCmd1bnRob3JwQGNneTEt
ZG9uYXJkOn4kIGlidl9yY19waW5ncG9uZyBmbGFzaC1jeGdiCiAgbG9jYWwgYWRkcmVzczog
IExJRCAweDAwMDAsIFFQTiAweDAwMDQzOCwgUFNOIDB4OWUwMGM4LCBHSUQgOjoKY2xpZW50
IHJlYWQ6IFN1Y2Nlc3MKQ291bGRuJ3QgcmVhZCByZW1vdGUgYWRkcmVzcwo=
--------------F3E860BB690A66CB1BD19BD1
Content-Type: text/plain; charset=UTF-8;
 name="mlx5-client-errors.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mlx5-client-errors.txt"

Z3VudGhvcnBAY2d5MS1kb25hcmQ6fiQgaWJfd3JpdGVfYncgLVIgLWQgbWx4NV8wIGZsYXNo
LXJkbWEKVW5leHBlY3RlZCBDTSBldmVudCBibCBibGthIDYKIFVuYWJsZSB0byBwZXJmb3Jt
IHJkbWFfY2xpZW50IGZ1bmN0aW9uCiBVbmFibGUgdG8gaW5pdCB0aGUgc29ja2V0IGNvbm5l
Y3Rpb24KZ3VudGhvcnBAY2d5MS1kb25hcmQ6fiQgaWJfd3JpdGVfYncgLVIgLWQgbWx4NV8w
IAoKKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiogV2FpdGluZyBmb3Ig
Y2xpZW50IHRvIGNvbm5lY3QuLi4gKgoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioKRnVuY3Rpb24gcmRtYV9hY2NlcHQgZmFpbGVkCiBVbmFibGUgdG8gcGVyZm9ybSBy
ZG1hX3NlcnZlciBmdW5jdGlvbgogVW5hYmxlIHRvIGluaXQgdGhlIHNvY2tldCBjb25uZWN0
aW9uCmd1bnRob3JwQGNneTEtZG9uYXJkOn4kIHJwaW5nIC1zCnJkbWFfYWNjZXB0OiBJbnZh
bGlkIGFyZ3VtZW50CmNvbm5lY3QgZXJyb3IgLTEKZ3VudGhvcnBAY2d5MS1kb25hcmQ6fiQg
cnBpbmcgLWMgLWEgZmxhc2gtcmRtYQpjbWEgZXZlbnQgUkRNQV9DTV9FVkVOVF9DT05ORUNU
X0VSUk9SLCBlcnJvciAtMQp3YWl0IGZvciBDT05ORUNURUQgc3RhdGUgNApjb25uZWN0IGVy
cm9yIC0xCmd1bnRob3JwQGNneTEtZG9uYXJkOn4kIHVjbWF0b3NlCmNtYXRvc2U6IHN0YXJ0
aW5nIHNlcnZlcgpjbWF0b3NlOiBmYWlsdXJlIGFjY2VwdGluZzogSW52YWxpZCBhcmd1bWVu
dApjbWF0b3NlOiBmYWlsaW5nIGNvbm5lY3Rpb24gcmVxdWVzdAp0ZXN0IGNvbXBsZXRlCnJl
dHVybiBzdGF0dXMgLTEKZ3VudGhvcnBAY2d5MS1kb25hcmQ6fiQgdWNtYXRvc2UgLXMgZmxh
c2gtcmRtYQpjbWF0b3NlOiBzdGFydGluZyBjbGllbnQKY21hdG9zZTogY29ubmVjdGluZwpj
bWF0b3NlOiBldmVudDogUkRNQV9DTV9FVkVOVF9DT05ORUNUX0VSUk9SLCBlcnJvcjogLTEK
dGVzdCBjb21wbGV0ZQpyZXR1cm4gc3RhdHVzIC0xCmd1bnRob3JwQGNneTEtZG9uYXJkOn4k
IGlidl9yY19waW5ncG9uZwogIGxvY2FsIGFkZHJlc3M6ICBMSUQgMHgwMDAzLCBRUE4gMHgw
MDA4NDcsIFBTTiAweDJhNjc4ZiwgR0lEIDo6CkZhaWxlZCB0byBtb2RpZnkgUVAgdG8gUlRS
CkNvdWxkbid0IGNvbm5lY3QgdG8gcmVtb3RlIFFQCmd1bnRob3JwQGNneTEtZG9uYXJkOn4k
IGlidl9yY19waW5ncG9uZyBmbGFzaC1yZG1hCiAgbG9jYWwgYWRkcmVzczogIExJRCAweDAw
MDMsIFFQTiAweDAwMDg0OCwgUFNOIDB4ZTAxNGJkLCBHSUQgOjoKICByZW1vdGUgYWRkcmVz
czogTElEIDB4MDAwMiwgUVBOIDB4MDAwODQ5LCBQU04gMHgyYmQzNDYsIEdJRCA6OgpGYWls
ZWQgdG8gbW9kaWZ5IFFQIHRvIFJUUgo=
--------------F3E860BB690A66CB1BD19BD1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
