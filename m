From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 00/13] mmu_notifier kill invalidate_page callback
Date: Tue, 29 Aug 2017 17:11:24 -0700
Message-ID: <CA+55aFz6ArJ-ADXiYCu6xMUzdY=mKBtkzfJmLaBohC6Ub9t2SQ@mail.gmail.com>
References: <20170829235447.10050-1-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170829235447.10050-1-jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bernhard Held <berny156-Mmb7MZpHnFY@public.gmane.org>, Adam Borowski <kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Steiner <steiner-sJ/iWh9BUns@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, DRI <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "open list:AMD IOMMU (AMD-VI)" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, ppc-dev <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

T24gVHVlLCBBdWcgMjksIDIwMTcgYXQgNDo1NCBQTSwgSsOpcsO0bWUgR2xpc3NlIDxqZ2xpc3Nl
QHJlZGhhdC5jb20+IHdyb3RlOgo+Cj4gTm90ZSB0aGlzIGlzIGJhcmVseSB0ZXN0ZWQuIEkgaW50
ZW5kIHRvIGRvIG1vcmUgdGVzdGluZyBvZiBuZXh0IGZldyBkYXlzCj4gYnV0IGkgZG8gbm90IGhh
dmUgYWNjZXNzIHRvIGFsbCBoYXJkd2FyZSB0aGF0IG1ha2UgdXNlIG9mIHRoZSBtbXVfbm90aWZp
ZXIKPiBBUEkuCgpUaGFua3MgZm9yIGRvaW5nIHRoaXMuCgo+IEZpcnN0IDIgcGF0Y2hlcyBjb252
ZXJ0IGV4aXN0aW5nIGNhbGwgb2YgbW11X25vdGlmaWVyX2ludmFsaWRhdGVfcGFnZSgpCj4gdG8g
bW11X25vdGlmaWVyX2ludmFsaWRhdGVfcmFuZ2UoKSBhbmQgYnJhY2tldCB0aG9zZSBjYWxsIHdp
dGggY2FsbCB0bwo+IG1tdV9ub3RpZmllcl9pbnZhbGlkYXRlX3JhbmdlX3N0YXJ0KCkvZW5kKCku
CgpPaywgdGhvc2UgdHdvIHBhdGNoZXMgYXJlIGEgYml0IG1vcmUgY29tcGxleCB0aGFuIEkgd2Fz
IGhvcGluZyBmb3IsCmJ1dCBub3QgKnRvbyogYmFkLgoKQW5kIHRoZSBmaW5hbCBlbmQgcmVzdWx0
IGNlcnRhaW5seSBsb29rcyBuaWNlOgoKPiAgMTYgZmlsZXMgY2hhbmdlZCwgNzQgaW5zZXJ0aW9u
cygrKSwgMjE0IGRlbGV0aW9ucygtKQoKWWVhaCwgcmVtb3ZpbmcgYWxsIHRob3NlIGludmFsaWRh
dGVfcGFnZSgpIG5vdGlmaWVycyBjZXJ0YWlubHkgbWFrZXMKZm9yIGEgbmljZSBwYXRjaC4KCkFu
ZCBJIGFjdHVhbGx5IHRoaW5rIHlvdSBtaXNzZWQgc29tZSBtb3JlIGxpbmVzIHRoYXQgY2FuIG5v
dyBiZQpyZW1vdmVkOiBrdm1fYXJjaF9tbXVfbm90aWZpZXJfaW52YWxpZGF0ZV9wYWdlKCkgc2hv
dWxkIG5vIGxvbmdlciBiZQpuZWVkZWQgZWl0aGVyLCBzbyB5b3UgY2FuIHJlbW92ZSBhbGwgb2Yg
dGhvc2UgdG9vIChtb3N0IG9mIHRoZW0gYXJlCmVtcHR5IGlubGluZSBmdW5jdGlvbnMsIGJ1dCB4
ODYgaGFzIG9uZSB0aGF0IGFjdHVhbGx5IGRvZXMgc29tZXRoaW5nLgoKU28gdGhlcmUncyBhbiBh
ZGRlZCAzMCBvciBzbyBkZWFkIGxpbmVzIHRoYXQgc2hvdWxkIGJlIHJlbW92ZWQgaW4gdGhlCmt2
bSBwYXRjaCwgSSB0aGluay4KCkJ1dCBmcm9tIGEgX3ZlcnlfIHF1aWNrIHJlYWQtdGhyb3VnaCB0
aGlzIGxvb2tzIGZpbmUuIEJ1dCBpdCBvYnZpb3VzbHkKbmVlZHMgdGVzdGluZy4KClBlb3BsZSAt
ICplc3BlY2lhbGx5KiB0aGUgcGVvcGxlIHdobyBzYXcgaXNzdWVzIHVuZGVyIEtWTSAtIGNhbiB5
b3UKdHJ5IG91dCBKw6lyw7RtZSdzIHBhdGNoLXNlcmllcz8gSSBhZGVkIHNvbWUgcGVvcGxlIHRv
IHRoZSBjYywgdGhlIGZ1bGwKc2VyaWVzIGlzIG9uIGxrbWwuIErDqXLDtG1lIC0gZG8geW91IGhh
dmUgYSBnaXQgYnJhbmNoIGZvciBwZW9wbGUgdG8KdGVzdCB0aGF0IHRoZXkgY291bGQgZWFzaWx5
IHB1bGwgYW5kIHRyeSBvdXQ/CgogICAgICAgICAgICAgICAgICAgIExpbnVzCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmlvbW11IG1haWxpbmcgbGlzdApp
b21tdUBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZwpodHRwczovL2xpc3RzLmxpbnV4Zm91bmRh
dGlvbi5vcmcvbWFpbG1hbi9saXN0aW5mby9pb21tdQ==
