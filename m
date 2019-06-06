From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH v2 hmm 08/11] mm/hmm: Remove racy protection against
 double-unregistration
Date: Thu,  6 Jun 2019 15:44:35 -0300
Message-ID: <20190606184438.31646-9-jgg@ziepe.ca>
References: <20190606184438.31646-1-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190606184438.31646-1-jgg-uk2M96/98Pc@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Felix.Kuehling-5C7GfCeVMHo@public.gmane.org
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgoKTm8gb3RoZXIgcmVnaXN0
ZXIvdW5yZWdpc3RlciBrZXJuZWwgQVBJIGF0dGVtcHRzIHRvIHByb3ZpZGUgdGhpcyBraW5kIG9m
CnByb3RlY3Rpb24gYXMgaXQgaXMgaW5oZXJlbnRseSByYWN5LCBzbyBqdXN0IGRyb3AgaXQuCgpD
YWxsZXJzIHNob3VsZCBwcm92aWRlIHRoZWlyIG93biBwcm90ZWN0aW9uLCBpdCBhcHBlYXJzIG5v
dXZlYXUgYWxyZWFkeQpkb2VzLCBidXQganVzdCBpbiBjYXNlIGRyb3AgYSBkZWJ1Z2dpbmcgUE9J
U09OLgoKU2lnbmVkLW9mZi1ieTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgpS
ZXZpZXdlZC1ieTogSsOpcsO0bWUgR2xpc3NlIDxqZ2xpc3NlQHJlZGhhdC5jb20+Ci0tLQogbW0v
aG1tLmMgfCA5ICsrLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNyBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9tbS9obW0uYyBiL21tL2htbS5jCmluZGV4IGM3MDJj
ZDcyNjUxYjUzLi42ODAyZGU3MDgwZDE3MiAxMDA2NDQKLS0tIGEvbW0vaG1tLmMKKysrIGIvbW0v
aG1tLmMKQEAgLTI4NCwxOCArMjg0LDEzIEBAIEVYUE9SVF9TWU1CT0woaG1tX21pcnJvcl9yZWdp
c3Rlcik7CiAgKi8KIHZvaWQgaG1tX21pcnJvcl91bnJlZ2lzdGVyKHN0cnVjdCBobW1fbWlycm9y
ICptaXJyb3IpCiB7Ci0Jc3RydWN0IGhtbSAqaG1tID0gUkVBRF9PTkNFKG1pcnJvci0+aG1tKTsK
LQotCWlmIChobW0gPT0gTlVMTCkKLQkJcmV0dXJuOworCXN0cnVjdCBobW0gKmhtbSA9IG1pcnJv
ci0+aG1tOwogCiAJZG93bl93cml0ZSgmaG1tLT5taXJyb3JzX3NlbSk7CiAJbGlzdF9kZWxfaW5p
dCgmbWlycm9yLT5saXN0KTsKLQkvKiBUbyBwcm90ZWN0IHVzIGFnYWluc3QgZG91YmxlIHVucmVn
aXN0ZXIgLi4uICovCi0JbWlycm9yLT5obW0gPSBOVUxMOwogCXVwX3dyaXRlKCZobW0tPm1pcnJv
cnNfc2VtKTsKLQogCWhtbV9wdXQoaG1tKTsKKwltZW1zZXQoJm1pcnJvci0+aG1tLCBQT0lTT05f
SU5VU0UsIHNpemVvZihtaXJyb3ItPmhtbSkpOwogfQogRVhQT1JUX1NZTUJPTChobW1fbWlycm9y
X3VucmVnaXN0ZXIpOwogCi0tIAoyLjIxLjAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGlu
Zm8vYW1kLWdmeA==
