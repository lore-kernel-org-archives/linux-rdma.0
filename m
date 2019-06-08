From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 hmm 02/11] mm/hmm: Use hmm_mirror not mm as an
 argument for hmm_range_register
Date: Sat, 8 Jun 2019 01:54:25 -0700
Message-ID: <20190608085425.GB32185@infradead.org>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-3-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190606184438.31646-3-jgg-uk2M96/98Pc@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Felix.Kuehling-5C7GfCeVMHo@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RllJLCBJIHZlcnkgbXVjaCBkaXNhZ3JlZSB3aXRoIHRoZSBkaXJlY3Rpb24gdGhpcyBpcyBtb3Zp
bmcuCgpzdHJ1Y3QgaG1tX21pcnJvciBsaXRlcmFsbHkgaXMgYSB0cml2aWFsIGR1cGxpY2F0aW9u
IG9mIHRoZQptbXVfbm90aWZpZXJzLiAgQWxsIHRoZXNlIGRyaXZlcnMgc2hvdWxkIGp1c3QgdXNl
IHRoZSBtbXVfbm90aWZpZXJzCmRpcmVjdGx5IGZvciB0aGUgbWlycm9yaW5nIHBhcnQgaW5zdGVh
ZCBvZiBidWlsZGluZyBhIHRoaW5nIHdyYXBwZXIKdGhhdCBhZGRzIG5vdGhpbmcgYnV0IGhlbHBp
bmcgdG8gbWFuYWdlIHRoZSBsaWZldGltZSBvZiBzdHJ1Y3QgaG1tLAp3aGljaCBzaG91bGRuJ3Qg
ZXhpc3QgdG8gc3RhcnQgd2l0aC4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3Rv
cC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQt
Z2Z4
