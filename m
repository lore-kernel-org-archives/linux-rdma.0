From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm, oom: distinguish blockable mode for mmu notifiers
Date: Mon, 23 Jul 2018 09:11:54 +0200
Message-ID: <20180723071154.GC17905@dhcp22.suse.cz>
References: <20180716115058.5559-1-mhocko@kernel.org>
 <20180720170902.d1137060c23802d55426aa03@linux-foundation.org>
 <20180723070306.GB17905@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180723070306.GB17905@dhcp22.suse.cz>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kvm@vger.kernel.org, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, David Airlie <airlied@linux.ie>, Sudeep Dutt <sudeep.dutt@intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, Dimitri Sivanich <sivanich@sgi.com>, linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org, Leon Romanovsky <leonro@mellanox.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Felix Kuehling <felix.kuehling@amd.com>, LKML <linux-kernel@vger.kernel.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christ>
List-Id: linux-rdma@vger.kernel.org

T24gTW9uIDIzLTA3LTE4IDA5OjAzOjA2LCBNaWNoYWwgSG9ja28gd3JvdGU6Cj4gT24gRnJpIDIw
LTA3LTE4IDE3OjA5OjAyLCBBbmRyZXcgTW9ydG9uIHdyb3RlOgo+IFsuLi5dCj4gPiBQbGVhc2Ug
dGFrZSBhIGxvb2s/Cj4gCj4gQXJlIHlvdSBPSyB0byBoYXZlIHRoZXNlIGluIGEgc2VwYXJhdGUg
cGF0Y2g/CgpCdHcuIEkgd2lsbCByZWJhc2UgdGhpcyBwYXRjaCBvbmNlIG9vbSBzdHVmZiBpbiBs
aW51eC1uZXh0IHNldHRsZXMuIEF0CmxlYXN0IG9vbV9sb2NrIHJlbW92YWwgZnJvbSBvb21fcmVh
cGVyIHdpbGwgY29uZmxpY3QuCgotLSAKTWljaGFsIEhvY2tvClNVU0UgTGFicwpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpkcmktZGV2ZWwgbWFpbGluZyBs
aXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVz
a3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2ZWwK
