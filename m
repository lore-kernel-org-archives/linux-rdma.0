From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH v4 hmm 09/12] mm/hmm: Remove racy protection against
 double-unregistration
Date: Mon, 24 Jun 2019 18:01:07 -0300
Message-ID: <20190624210110.5098-10-jgg@ziepe.ca>
References: <20190624210110.5098-1-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190624210110.5098-1-jgg-uk2M96/98Pc@public.gmane.org>
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
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Philip Yang <Philip.Yang-5C7GfCeVMHo@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Ben Skeggs <bskeggs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgoKTm8gb3RoZXIgcmVnaXN0
ZXIvdW5yZWdpc3RlciBrZXJuZWwgQVBJIGF0dGVtcHRzIHRvIHByb3ZpZGUgdGhpcyBraW5kIG9m
CnByb3RlY3Rpb24gYXMgaXQgaXMgaW5oZXJlbnRseSByYWN5LCBzbyBqdXN0IGRyb3AgaXQuCgpD
YWxsZXJzIHNob3VsZCBwcm92aWRlIHRoZWlyIG93biBwcm90ZWN0aW9uLCBhbmQgaXQgYXBwZWFy
cyBub3V2ZWF1CmFscmVhZHkgZG9lcy4KClNpZ25lZC1vZmYtYnk6IEphc29uIEd1bnRob3JwZSA8
amdnQG1lbGxhbm94LmNvbT4KUmV2aWV3ZWQtYnk6IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUBy
ZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogSm9obiBIdWJiYXJkIDxqaHViYmFyZEBudmlkaWEuY29t
PgpSZXZpZXdlZC1ieTogUmFscGggQ2FtcGJlbGwgPHJjYW1wYmVsbEBudmlkaWEuY29tPgpSZXZp
ZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+ClRlc3RlZC1ieTogUGhpbGlw
IFlhbmcgPFBoaWxpcC5ZYW5nQGFtZC5jb20+Ci0tLQp2MwotIERyb3AgcG9pc29uLCBsb29rcyBs
aWtlIHRoZXJlIGFyZSBubyBuZXcgcGF0Y2hlcyB0aGF0IHdpbGwgdXNlIHRoaXMKICB3cm9uZyAo
Q2hyaXN0b3BoKQotLS0KIG1tL2htbS5jIHwgOCArLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEg
aW5zZXJ0aW9uKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL21tL2htbS5jIGIvbW0v
aG1tLmMKaW5kZXggNmY1ZGM2ZDU2OGZlYjEuLjJlZjE0YjJiNTUwNWY2IDEwMDY0NAotLS0gYS9t
bS9obW0uYworKysgYi9tbS9obW0uYwpAQCAtMjc2LDE3ICsyNzYsMTEgQEAgRVhQT1JUX1NZTUJP
TChobW1fbWlycm9yX3JlZ2lzdGVyKTsKICAqLwogdm9pZCBobW1fbWlycm9yX3VucmVnaXN0ZXIo
c3RydWN0IGhtbV9taXJyb3IgKm1pcnJvcikKIHsKLQlzdHJ1Y3QgaG1tICpobW0gPSBSRUFEX09O
Q0UobWlycm9yLT5obW0pOwotCi0JaWYgKGhtbSA9PSBOVUxMKQotCQlyZXR1cm47CisJc3RydWN0
IGhtbSAqaG1tID0gbWlycm9yLT5obW07CiAKIAlkb3duX3dyaXRlKCZobW0tPm1pcnJvcnNfc2Vt
KTsKIAlsaXN0X2RlbF9pbml0KCZtaXJyb3ItPmxpc3QpOwotCS8qIFRvIHByb3RlY3QgdXMgYWdh
aW5zdCBkb3VibGUgdW5yZWdpc3RlciAuLi4gKi8KLQltaXJyb3ItPmhtbSA9IE5VTEw7CiAJdXBf
d3JpdGUoJmhtbS0+bWlycm9yc19zZW0pOwotCiAJaG1tX3B1dChobW0pOwogfQogRVhQT1JUX1NZ
TUJPTChobW1fbWlycm9yX3VucmVnaXN0ZXIpOwotLSAKMi4yMi4wCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwphbWQtZ2Z4IG1haWxpbmcgbGlzdAphbWQt
Z2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9t
YWlsbWFuL2xpc3RpbmZvL2FtZC1nZng=
