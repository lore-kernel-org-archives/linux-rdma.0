From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Wed, 11 Jul 2018 11:03:53 +0200
Message-ID: <20180711090353.GD20050@dhcp22.suse.cz>
References: <20180622150242.16558-1-mhocko@kernel.org>
 <20180627074421.GF32348@dhcp22.suse.cz>
 <20180709122908.GJ22049@dhcp22.suse.cz>
 <20180710134040.GG3014@mtr-leonro.mtl.com>
 <20180710141410.GP14284@dhcp22.suse.cz>
 <20180710162020.GJ3014@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180710162020.GJ3014-U/DQcQFIOTAkZy+6dPanYNBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Felix Kuehling <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "David (ChunMing) Zhou" <David1.Zhou-5C7GfCeVMHo@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>Mike Marciniszyn <mi>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlIDEwLTA3LTE4IDE5OjIwOjIwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6Cj4gT24gVHVl
LCBKdWwgMTAsIDIwMTggYXQgMDQ6MTQ6MTBQTSArMDIwMCwgTWljaGFsIEhvY2tvIHdyb3RlOgo+
ID4gT24gVHVlIDEwLTA3LTE4IDE2OjQwOjQwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6Cj4gPiA+
IE9uIE1vbiwgSnVsIDA5LCAyMDE4IGF0IDAyOjI5OjA4UE0gKzAyMDAsIE1pY2hhbCBIb2NrbyB3
cm90ZToKPiA+ID4gPiBPbiBXZWQgMjctMDYtMTggMDk6NDQ6MjEsIE1pY2hhbCBIb2NrbyB3cm90
ZToKPiA+ID4gPiA+IFRoaXMgaXMgdGhlIHYyIG9mIFJGQyBiYXNlZCBvbiB0aGUgZmVlZGJhY2sg
SSd2ZSByZWNlaXZlZCBzbyBmYXIuIFRoZQo+ID4gPiA+ID4gY29kZSBldmVuIGNvbXBpbGVzIGFz
IGEgYm9udXMgOykgSSBoYXZlbid0IHJ1bnRpbWUgdGVzdGVkIGl0IHlldCwgbW9zdGx5Cj4gPiA+
ID4gPiBiZWNhdXNlIEkgaGF2ZSBubyBpZGVhIGhvdy4KPiA+ID4gPiA+Cj4gPiA+ID4gPiBBbnkg
ZnVydGhlciBmZWVkYmFjayBpcyBoaWdobHkgYXBwcmVjaWF0ZWQgb2YgY291cnNlLgo+ID4gPiA+
Cj4gPiA+ID4gQW55IG90aGVyIGZlZWRiYWNrIGJlZm9yZSBJIHBvc3QgdGhpcyBhcyBub24tUkZD
Pwo+ID4gPgo+ID4gPiBGcm9tIG1seDUgcGVyc3BlY3RpdmUsIHdobyBpcyBwcmltYXJ5IHVzZXIg
b2YgdW1lbV9vZHAuYyB5b3VyIGNoYW5nZSBsb29rcyBvay4KPiA+Cj4gPiBDYW4gSSBhc3N1bWUg
eW91ciBBY2tlZC1ieT8KPiAKPiBJIGRpZG4ndCBoYXZlIGEgY2hhbmNlIHRvIHRlc3QgaXQgYmVj
YXVzZSBpdCBhcHBsaWVzIG9uIG91ciByZG1hLW5leHQsIGJ1dAo+IGZhaWxzIHRvIGNvbXBpbGUu
CgpXaGF0IGlzIHRoZSBjb21waWxhdGlvbiBwcm9ibGVtPyBJcyBpdCBjYXVzZWQgYnkgdGhlIHBh
dGNoIG9yIHNvbWUgb3RoZXIKdW5yZWxhdGVkIGNoYW5nZWQ/Ci0tIApNaWNoYWwgSG9ja28KU1VT
RSBMYWJzCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmFt
ZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8v
bGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vYW1kLWdmeAo=
