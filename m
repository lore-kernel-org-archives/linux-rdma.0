From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Fri, 24 Aug 2018 14:33:41 +0200
Message-ID: <20180824123341.GN29735@dhcp22.suse.cz>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <8cbfb09f-0c5a-8d43-1f5e-f3ff7612e289@I-love.SAKURA.ne.jp>
 <20180824113248.GH29735@dhcp22.suse.cz>
 <b088e382-e90e-df63-a079-19b2ae2b985d@gmail.com>
 <20180824115226.GK29735@dhcp22.suse.cz>
 <a27ad1a3-34bd-6b7d-fd09-7737ec3c888d@gmail.com>
 <20180824120339.GL29735@dhcp22.suse.cz>
 <eb546bcb-9c5f-7d5d-43a7-bfde489f0e7f@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <eb546bcb-9c5f-7d5d-43a7-bfde489f0e7f-5C7GfCeVMHo@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David (ChunMing) Zhou" <David1.Zhou-5C7GfCeVMHo@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Mike Marciniszyn <mike.marci>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpIDI0LTA4LTE4IDE0OjE4OjQ0LCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+IEFtIDI0
LjA4LjIwMTggdW0gMTQ6MDMgc2NocmllYiBNaWNoYWwgSG9ja286Cj4gPiBPbiBGcmkgMjQtMDgt
MTggMTM6NTc6NTIsIENocmlzdGlhbiBLw7ZuaWcgd3JvdGU6Cj4gPiA+IEFtIDI0LjA4LjIwMTgg
dW0gMTM6NTIgc2NocmllYiBNaWNoYWwgSG9ja286Cj4gPiA+ID4gT24gRnJpIDI0LTA4LTE4IDEz
OjQzOjE2LCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+ID4gWy4uLl0KPiA+ID4gPiA+IFRoYXQg
d29uJ3Qgd29yayBsaWtlIHRoaXMgdGhlcmUgbWlnaHQgYmUgbXVsdGlwbGUKPiA+ID4gPiA+IGlu
dmFsaWRhdGVfcmFuZ2Vfc3RhcnQoKS9pbnZhbGlkYXRlX3JhbmdlX2VuZCgpIHBhaXJzIG9wZW4g
YXQgdGhlIHNhbWUgdGltZS4KPiA+ID4gPiA+IEUuZy4gdGhlIGxvY2sgbWlnaHQgYmUgdGFrZW4g
cmVjdXJzaXZlbHkgYW5kIHRoYXQgaXMgaWxsZWdhbCBmb3IgYQo+ID4gPiA+ID4gcndfc2VtYXBo
b3JlLgo+ID4gPiA+IEkgYW0gbm90IHN1cmUgSSBmb2xsb3cuIEFyZSB5b3Ugc2F5aW5nIHRoYXQg
b25lIGludmFsaWRhdGVfcmFuZ2UgbWlnaHQKPiA+ID4gPiB0cmlnZ2VyIGFub3RoZXIgb25lIGZy
b20gdGhlIHNhbWUgcGF0aD8KPiA+ID4gTm8sIGJ1dCB3aGF0IGNhbiBoYXBwZW4gaXM6Cj4gPiA+
IAo+ID4gPiBpbnZhbGlkYXRlX3JhbmdlX3N0YXJ0KEEsQik7Cj4gPiA+IGludmFsaWRhdGVfcmFu
Z2Vfc3RhcnQoQyxEKTsKPiA+ID4gLi4uCj4gPiA+IGludmFsaWRhdGVfcmFuZ2VfZW5kKEMsRCk7
Cj4gPiA+IGludmFsaWRhdGVfcmFuZ2VfZW5kKEEsQik7Cj4gPiA+IAo+ID4gPiBHcmFiYmluZyB0
aGUgcmVhZCBsb2NrIHR3aWNlIHdvdWxkIGJlIGlsbGVnYWwgaW4gdGhpcyBjYXNlLgo+ID4gSSBh
bSBzb3JyeSBidXQgSSBzdGlsbCBkbyBub3QgZm9sbG93LiBXaGF0IGlzIHRoZSBjb250ZXh0IHRo
ZSB0d28gYXJlCj4gPiBjYWxsZWQgZnJvbT8KPiAKPiBJIGRvbid0IGhhdmUgdGhlIHNsaWdodGVz
dCBpZGVhLgo+IAo+ID4gQ2FuIHlvdSBnaXZlIG1lIGFuIGV4YW1wbGUuIEkgc2ltcGx5IGRvIG5v
dCBzZWUgaXQgaW4gdGhlCj4gPiBjb2RlLCBtb3N0bHkgYmVjYXVzZSBJIGFtIG5vdCBmYW1pbGlh
ciB3aXRoIGl0Lgo+IAo+IEknbSBuZWl0aGVyLgo+IAo+IFdlIHN0dW1ibGVkIG92ZXIgdGhhdCBi
eSBwdXJlIG9ic2VydmF0aW9uIGFuZCBhZnRlciBkaXNjdXNzaW5nIHRoZSBwcm9ibGVtCj4gd2l0
aCBKZXJvbWUgY2FtZSB1cCB3aXRoIHRoaXMgc29sdXRpb24uCj4gCj4gTm8gaWRlYSB3aGVyZSBl
eGFjdGx5IHRoYXQgY2FzZSBjb21lcyBmcm9tLCBidXQgSSBjYW4gY29uZmlybSB0aGF0IGl0IGlu
ZGVlZAo+IGhhcHBlbnMuCgpUaGlraW5nIGFib3V0IGl0IHNvbWUgbW9yZSwgSSBjYW4gaW1hZ2lu
ZSB0aGF0IGEgbm90aWZpZXIgY2FsbGJhY2sgd2hpY2gKcGVyZm9ybXMgYW4gYWxsb2NhdGlvbiBt
aWdodCB0cmlnZ2VyIGEgbWVtb3J5IHJlY2xhaW0gYW5kIHRoYXQgaW4gdHVybgptaWdodCB0cmln
Z2VyIGEgbm90aWZpZXIgdG8gYmUgaW52b2tlZCBhbmQgcmVjdXJzZS4gQnV0IG5vdGlmaWVyCnNo
b3VsZG4ndCByZWFsbHkgYWxsb2NhdGUgbWVtb3J5LiBUaGV5IGFyZSBjYWxsZWQgZnJvbSBkZWVw
IE1NIGNvZGUKcGF0aHMgYW5kIHRoaXMgd291bGQgYmUgZXh0cmVtZWx5IGRlYWRsb2NrIHByb25l
LiBNYXliZSBKZXJvbWUgY2FuIGNvbWUKdXAgc29tZSBtb3JlIHJlYWxpc3RpYyBzY2VuYXJpby4g
SWYgbm90IHRoZW4gSSB3b3VsZCBwcm9wb3NlIHRvIHNpbXBsaWZ5CnRoZSBsb2NraW5nIGhlcmUu
IFdlIGhhdmUgbG9ja2RlcCB0byBjYXRjaCBzZWxmIGRlYWRsb2NrcyBhbmQgaXQgaXMKYWx3YXlz
IGJldHRlciB0byBoYW5kbGUgYSBzcGVjaWZpYyBpc3N1ZSByYXRoZXIgdGhhbiBoYXZpbmcgYSBj
b2RlCndpdGhvdXQgYSBjbGVhciBpbmRpY2F0aW9uIGhvdyBpdCBjYW4gcmVjdXJzZS4KLS0gCk1p
Y2hhbCBIb2NrbwpTVVNFIExhYnMKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3Rv
cC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQt
Z2Z4Cg==
