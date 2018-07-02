From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Mon, 2 Jul 2018 14:56:29 +0200
Message-ID: <20180702125629.GR19043@dhcp22.suse.cz>
References: <20180622150242.16558-1-mhocko@kernel.org>
 <20180627074421.GF32348@dhcp22.suse.cz>
 <71f4184c-21ea-5af1-eeb6-bf7787614e2d@amd.com>
 <20180702115423.GK19043@dhcp22.suse.cz>
 <725cb1ad-01b0-42b5-56f0-c08c29804cb4@amd.com>
 <20180702122003.GN19043@dhcp22.suse.cz>
 <02d1d52c-f534-f899-a18c-a3169123ac7c@amd.com>
 <20180702123521.GO19043@dhcp22.suse.cz>
 <91ad1106-6bd4-7d2c-4d40-7c5be945ba36@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <91ad1106-6bd4-7d2c-4d40-7c5be945ba36-5C7GfCeVMHo@public.gmane.org>
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
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David (ChunMing) Zhou" <David1.Zhou-5C7GfCeVMHo@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis
List-Id: linux-rdma@vger.kernel.org

T24gTW9uIDAyLTA3LTE4IDE0OjM5OjUwLCBDaHJpc3RpYW4gS8O2bmlnIHdyb3RlOgpbLi4uXQo+
IE5vdCB3YW50aW5nIHRvIGJsb2NrIHNvbWV0aGluZyBhcyBpbXBvcnRhbnQgYXMgdGhpcywgc28g
ZmVlbCBmcmVlIHRvIGFkZCBhbgo+IEFja2VkLWJ5OiBDaHJpc3RpYW4gS8O2bmlnIDxjaHJpc3Rp
YW4ua29lbmlnQGFtZC5jb20+IHRvIHRoZSBwYXRjaC4KClRoYW5rcyBhIGxvdCEKCj4gTGV0J3Mg
cmF0aGVyIGZhY2UgdGhlIG5leHQgdG9waWM6IEFueSBpZGVhIGhvdyB0byBydW50aW1lIHRlc3Qg
dGhpcz8KClRoaXMgaXMgYSBnb29kIHF1ZXN0aW9uIGluZGVlZC4gT25lIHdheSB0byBkbyB0aGF0
IHdvdWxkIGJlIHRyaWdnZXJpbmcKdGhlIE9PTSBraWxsZXIgZnJvbSB0aGUgY29udGV4dCB3aGlj
aCB1c2VzIGVhY2ggb2YgdGhlc2UgbW11IG5vdGlmaWVycwoob25lIGF0IHRoZSB0aW1lKSBhbmQg
c2VlIGhvdyB0aGF0IHdvcmtzLiBZb3Ugd291bGQgc2VlIHRoZSBub3RlIGluIHRoZQpsb2cgd2hl
bmV2ZXIgdGhlIG5vdGlmaWVyIHdvdWxkIGJsb2NrLiBUaGUgcHJpbWFyeSB0aGluZyB0byB0ZXN0
IGlzIGhvdwpvZnRlbiB0aGUgb29tIHJlYXBlciByZWFsbHkgaGFkIHRvIGJhY2sgb2ZmIGNvbXBs
ZXRlbHkuCgo+IEkgbWVhbiBJIGNhbiByYXRoZXIgZWFzaWx5IHByb3ZpZGUgYSB0ZXN0IHdoaWNo
IGNyYXNoZXMgYW4gQU1EIEdQVSwgd2hpY2ggaW4KPiB0dXJuIHRoZW4gd291bGQgbWVhbiB0aGF0
IHRoZSBNTVUgbm90aWZpZXIgd291bGQgYmxvY2sgZm9yZXZlciB3aXRob3V0IHRoaXMKPiBwYXRj
aC4KCldlbGwsIHlvdSBkbyBub3QgcmVhbGx5IGhhdmUgdG8gZ28gdGhhdCBmYXIuIEl0IHNob3Vs
ZCBiZSBzdWZmaWNpZW50IHRvCmRvIHRoZSBhYm92ZS4gVGhlIGN1cnJlbnQgY29kZSB3b3VsZCBz
aW1wbHkgYmFjayBvZiB3aXRob3V0IHJlbGVhc2luZwphbnkgbWVtb3J5LiBUaGUgcGF0Y2ggc2hv
dWxkIGhlbHAgdG8gcmVjbGFpbSBzb21lIG1lbW9yeS4KIAo+IEJ1dCBkbyB5b3Uga25vdyBhIHdh
eSB0byBsZXQgdGhlIE9PTSBraWxsZXIga2lsbCBhIHNwZWNpZmljIHByb2Nlc3M/CgpZZXMsIHlv
dSBjYW4gc2V0IGl0cyBvb21fc2NvcmVfYWRqIHRvIDEwMDAgd2hpY2ggbWVhbnMgYWx3YXlzIHNl
bGVjdAp0aGF0IHRhc2suCi0tIApNaWNoYWwgSG9ja28KU1VTRSBMYWJzCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFt
ZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
L21haWxtYW4vbGlzdGluZm8vYW1kLWdmeAo=
