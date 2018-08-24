From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Fri, 24 Aug 2018 14:18:44 +0200
Message-ID: <eb546bcb-9c5f-7d5d-43a7-bfde489f0e7f@amd.com>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <8cbfb09f-0c5a-8d43-1f5e-f3ff7612e289@I-love.SAKURA.ne.jp>
 <20180824113248.GH29735@dhcp22.suse.cz>
 <b088e382-e90e-df63-a079-19b2ae2b985d@gmail.com>
 <20180824115226.GK29735@dhcp22.suse.cz>
 <a27ad1a3-34bd-6b7d-fd09-7737ec3c888d@gmail.com>
 <20180824120339.GL29735@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20180824120339.GL29735-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David (ChunMing) Zhou" <David1.Zhou-5C7GfCeVMHo@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jue
List-Id: linux-rdma@vger.kernel.org

QW0gMjQuMDguMjAxOCB1bSAxNDowMyBzY2hyaWViIE1pY2hhbCBIb2NrbzoKPiBPbiBGcmkgMjQt
MDgtMTggMTM6NTc6NTIsIENocmlzdGlhbiBLw7ZuaWcgd3JvdGU6Cj4+IEFtIDI0LjA4LjIwMTgg
dW0gMTM6NTIgc2NocmllYiBNaWNoYWwgSG9ja286Cj4+PiBPbiBGcmkgMjQtMDgtMTggMTM6NDM6
MTYsIENocmlzdGlhbiBLw7ZuaWcgd3JvdGU6Cj4gWy4uLl0KPj4+PiBUaGF0IHdvbid0IHdvcmsg
bGlrZSB0aGlzIHRoZXJlIG1pZ2h0IGJlIG11bHRpcGxlCj4+Pj4gaW52YWxpZGF0ZV9yYW5nZV9z
dGFydCgpL2ludmFsaWRhdGVfcmFuZ2VfZW5kKCkgcGFpcnMgb3BlbiBhdCB0aGUgc2FtZSB0aW1l
Lgo+Pj4+IEUuZy4gdGhlIGxvY2sgbWlnaHQgYmUgdGFrZW4gcmVjdXJzaXZlbHkgYW5kIHRoYXQg
aXMgaWxsZWdhbCBmb3IgYQo+Pj4+IHJ3X3NlbWFwaG9yZS4KPj4+IEkgYW0gbm90IHN1cmUgSSBm
b2xsb3cuIEFyZSB5b3Ugc2F5aW5nIHRoYXQgb25lIGludmFsaWRhdGVfcmFuZ2UgbWlnaHQKPj4+
IHRyaWdnZXIgYW5vdGhlciBvbmUgZnJvbSB0aGUgc2FtZSBwYXRoPwo+PiBObywgYnV0IHdoYXQg
Y2FuIGhhcHBlbiBpczoKPj4KPj4gaW52YWxpZGF0ZV9yYW5nZV9zdGFydChBLEIpOwo+PiBpbnZh
bGlkYXRlX3JhbmdlX3N0YXJ0KEMsRCk7Cj4+IC4uLgo+PiBpbnZhbGlkYXRlX3JhbmdlX2VuZChD
LEQpOwo+PiBpbnZhbGlkYXRlX3JhbmdlX2VuZChBLEIpOwo+Pgo+PiBHcmFiYmluZyB0aGUgcmVh
ZCBsb2NrIHR3aWNlIHdvdWxkIGJlIGlsbGVnYWwgaW4gdGhpcyBjYXNlLgo+IEkgYW0gc29ycnkg
YnV0IEkgc3RpbGwgZG8gbm90IGZvbGxvdy4gV2hhdCBpcyB0aGUgY29udGV4dCB0aGUgdHdvIGFy
ZQo+IGNhbGxlZCBmcm9tPwoKSSBkb24ndCBoYXZlIHRoZSBzbGlnaHRlc3QgaWRlYS4KCj4gQ2Fu
IHlvdSBnaXZlIG1lIGFuIGV4YW1wbGUuIEkgc2ltcGx5IGRvIG5vdCBzZWUgaXQgaW4gdGhlCj4g
Y29kZSwgbW9zdGx5IGJlY2F1c2UgSSBhbSBub3QgZmFtaWxpYXIgd2l0aCBpdC4KCkknbSBuZWl0
aGVyLgoKV2Ugc3R1bWJsZWQgb3ZlciB0aGF0IGJ5IHB1cmUgb2JzZXJ2YXRpb24gYW5kIGFmdGVy
IGRpc2N1c3NpbmcgdGhlIApwcm9ibGVtIHdpdGggSmVyb21lIGNhbWUgdXAgd2l0aCB0aGlzIHNv
bHV0aW9uLgoKTm8gaWRlYSB3aGVyZSBleGFjdGx5IHRoYXQgY2FzZSBjb21lcyBmcm9tLCBidXQg
SSBjYW4gY29uZmlybSB0aGF0IGl0IAppbmRlZWQgaGFwcGVucy4KClJlZ2FyZHMsCkNocmlzdGlh
bi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdm
eCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0
cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4Cg==
