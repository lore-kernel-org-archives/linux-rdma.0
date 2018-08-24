From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Fri, 24 Aug 2018 15:01:32 +0200
Message-ID: <20180824130132.GP29735@dhcp22.suse.cz>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <8cbfb09f-0c5a-8d43-1f5e-f3ff7612e289@I-love.SAKURA.ne.jp>
 <20180824113248.GH29735@dhcp22.suse.cz>
 <b088e382-e90e-df63-a079-19b2ae2b985d@gmail.com>
 <20180824115226.GK29735@dhcp22.suse.cz>
 <a27ad1a3-34bd-6b7d-fd09-7737ec3c888d@gmail.com>
 <20180824120339.GL29735@dhcp22.suse.cz>
 <eb546bcb-9c5f-7d5d-43a7-bfde489f0e7f@amd.com>
 <20180824123341.GN29735@dhcp22.suse.cz>
 <b11df415-baf8-0a41-3c16-60dfe8d32bd3@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b11df415-baf8-0a41-3c16-60dfe8d32bd3-5C7GfCeVMHo@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David (ChunMing) Zhou" <David1.Zhou-5C7GfCeVMHo@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Juerg
List-Id: linux-rdma@vger.kernel.org

T24gRnJpIDI0LTA4LTE4IDE0OjUyOjI2LCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgo+IEFtIDI0
LjA4LjIwMTggdW0gMTQ6MzMgc2NocmllYiBNaWNoYWwgSG9ja286ClsuLi5dCj4gPiBUaGlraW5n
IGFib3V0IGl0IHNvbWUgbW9yZSwgSSBjYW4gaW1hZ2luZSB0aGF0IGEgbm90aWZpZXIgY2FsbGJh
Y2sgd2hpY2gKPiA+IHBlcmZvcm1zIGFuIGFsbG9jYXRpb24gbWlnaHQgdHJpZ2dlciBhIG1lbW9y
eSByZWNsYWltIGFuZCB0aGF0IGluIHR1cm4KPiA+IG1pZ2h0IHRyaWdnZXIgYSBub3RpZmllciB0
byBiZSBpbnZva2VkIGFuZCByZWN1cnNlLiBCdXQgbm90aWZpZXIKPiA+IHNob3VsZG4ndCByZWFs
bHkgYWxsb2NhdGUgbWVtb3J5LiBUaGV5IGFyZSBjYWxsZWQgZnJvbSBkZWVwIE1NIGNvZGUKPiA+
IHBhdGhzIGFuZCB0aGlzIHdvdWxkIGJlIGV4dHJlbWVseSBkZWFkbG9jayBwcm9uZS4gTWF5YmUg
SmVyb21lIGNhbiBjb21lCj4gPiB1cCBzb21lIG1vcmUgcmVhbGlzdGljIHNjZW5hcmlvLiBJZiBu
b3QgdGhlbiBJIHdvdWxkIHByb3Bvc2UgdG8gc2ltcGxpZnkKPiA+IHRoZSBsb2NraW5nIGhlcmUu
IFdlIGhhdmUgbG9ja2RlcCB0byBjYXRjaCBzZWxmIGRlYWRsb2NrcyBhbmQgaXQgaXMKPiA+IGFs
d2F5cyBiZXR0ZXIgdG8gaGFuZGxlIGEgc3BlY2lmaWMgaXNzdWUgcmF0aGVyIHRoYW4gaGF2aW5n
IGEgY29kZQo+ID4gd2l0aG91dCBhIGNsZWFyIGluZGljYXRpb24gaG93IGl0IGNhbiByZWN1cnNl
Lgo+IAo+IFdlbGwgSSBhZ3JlZSB0aGF0IHdlIHNob3VsZCBwcm9iYWJseSBmaXggdGhhdCwgYnV0
IEkgaGF2ZSBzb21lIGNvbmNlcm5zIHRvCj4gcmVtb3ZlIHRoZSBleGlzdGluZyB3b3JrYXJvdW5k
Lgo+IAo+IFNlZSB3ZSBhZGRlZCB0aGF0IHRvIGdldCByaWQgb2YgYSByZWFsIHByb2JsZW0gaW4g
YSBjdXN0b21lciBlbnZpcm9ubWVudCBhbmQKPiBJIGRvbid0IHdhbnQgdG8gdGhhdCB0byBzaG93
IHVwIGFnYWluLgoKSXQgd291bGQgcmVhbGx5IGhlbHAgdG8ga25vdyBtb3JlIGFib3V0IHRoYXQg
Y2FzZSBhbmQgZml4IGl0IHByb3Blcmx5CnJhdGhlciB0aGFuIHdvcmthcm91bmQgaXQgbGlrZSB0
aGlzLiBBbnl3YXksIGxldCBtZSB0aGluayBob3cgdG8gaGFuZGxlCnRoZSBub24tYmxvY2tpbmcg
bm90aWZpZXIgaW52b2NhdGlvbiB0aGVuLiBJIHdhcyBub3QgYWJsZSB0byBjb21lIHVwCndpdGgg
YW55dGhpbmcgcmVtb3RlbHkgc2FuZSB5ZXQuCi0tIApNaWNoYWwgSG9ja28KU1VTRSBMYWJzCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmFtZC1nZnggbWFp
bGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeAo=
