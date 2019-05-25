From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Run a dedicated hmm.git for 5.3
Date: Sat, 25 May 2019 15:52:10 -0700
Message-ID: <20190525155210.8a9a66385ac8169d0e144225@linux-foundation.org>
References: <20190522235737.GD15389@ziepe.ca>
 <20190523150432.GA5104@redhat.com>
 <20190523154149.GB12159@ziepe.ca>
 <20190523155207.GC5104@redhat.com>
 <20190523163429.GC12159@ziepe.ca>
 <20190523173302.GD5104@redhat.com>
 <20190523175546.GE12159@ziepe.ca>
 <20190523182458.GA3571@redhat.com>
 <20190523191038.GG12159@ziepe.ca>
 <20190524064051.GA28855@infradead.org>
 <20190524124455.GB16845@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20190524124455.GB16845@ziepe.ca>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, linux-mm@kvack.org, linux-rdma@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>, Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-kernel@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, Kaike Wan <kaike.wan@intel.com>, Christoph Hellwig <hch@infradead.org>, Leon Romanovsky <leonro@mellanox.com>, Jerome Glisse <jglisse@redhat.com>, Moni Shoua <monis@mellanox.com>, Artemy Kovalyov <artemyko@mellanox.com>, Dave Airlie <airlied@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

T24gRnJpLCAyNCBNYXkgMjAxOSAwOTo0NDo1NSAtMDMwMCBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6
aWVwZS5jYT4gd3JvdGU6Cgo+IE5vdyB0aGF0IC1tbSBtZXJnZWQgdGhlIGJhc2ljIGhtbSBBUEkg
c2tlbGV0b24gSSB0aGluayBydW5uaW5nIGxpa2UKPiB0aGlzIHdvdWxkIGdldCB1cyBxdWlja2x5
IHRvIHRoZSBwbGFjZSB3ZSBhbGwgd2FudDogY29tcHJlaGVuc2l2ZSBpbiB0cmVlCj4gdXNlcnMg
b2YgaG1tLgo+IAo+IEFuZHJldywgd291bGQgdGhpcyBiZSBhY2NlcHRhYmxlIHRvIHlvdT8KClN1
cmUuICBQbGVhc2UgdGFrZSBjYXJlIG5vdCB0byBwZXJtaXQgdGhpcyB0byByZWR1Y2UgdGhlIGFt
b3VudCBvZgpleHBvc3VyZSBhbmQgcmV2aWV3IHdoaWNoIHRoZSBjb3JlIEhNTSBwaWVjZXMgZ2V0
LgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRl
dmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8v
bGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
