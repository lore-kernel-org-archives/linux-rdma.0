From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2 hmm 02/11] mm/hmm: Use hmm_mirror not mm as an
 argument for hmm_range_register
Date: Mon, 10 Jun 2019 10:09:15 -0300
Message-ID: <20190610130915.GA18468@ziepe.ca>
References: <20190606184438.31646-1-jgg@ziepe.ca>
 <20190606184438.31646-3-jgg@ziepe.ca>
 <4a391bd4-287c-5f13-3bca-c6a46ff8d08c@nvidia.com>
 <e460ddf5-9ed3-7f3b-98ce-526c12fdb8b1@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e460ddf5-9ed3-7f3b-98ce-526c12fdb8b1-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Ralph Campbell <rcampbell-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Felix.Kuehling-5C7GfCeVMHo@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCBKdW4gMDcsIDIwMTkgYXQgMDM6Mzk6MDZQTSAtMDcwMCwgUmFscGggQ2FtcGJlbGwg
d3JvdGU6Cj4gPiA+ICvCoMKgwqAgcmFuZ2UtPmhtbSA9IGhtbTsKPiA+ID4gK8KgwqDCoCBrcmVm
X2dldCgmaG1tLT5rcmVmKTsKPiA+ID4gwqDCoMKgwqDCoCAvKiBJbml0aWFsaXplIHJhbmdlIHRv
IHRyYWNrIENQVSBwYWdlIHRhYmxlIHVwZGF0ZXMuICovCj4gPiA+IMKgwqDCoMKgwqAgbXV0ZXhf
bG9jaygmaG1tLT5sb2NrKTsKPiA+ID4gCj4gCj4gSSBmb3Jnb3QgdG8gYWRkIHRoYXQgSSB0aGlu
ayB5b3UgY2FuIGRlbGV0ZSB0aGUgZHVwbGljYXRlCj4gICAgICJyYW5nZS0+aG1tID0gaG1tOyIK
PiBoZXJlIGJldHdlZW4gdGhlIG11dGV4X2xvY2svdW5sb2NrLgoKRG9uZSwgdGhhbmtzCgpKYXNv
bgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwphbWQtZ2Z4
IG1haWxpbmcgbGlzdAphbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3Rz
LmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2FtZC1nZng=
