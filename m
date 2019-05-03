From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v13 16/20] IB/mlx4, arm64: untag user pointers in
 mlx4_get_umem_mr
Date: Fri, 3 May 2019 17:28:46 +0100
Message-ID: <20190503162846.GI55449@arrakis.emea.arm.com>
References: <cover.1553093420.git.andreyknvl@google.com>
 <1e2824fd77e8eeb351c6c6246f384d0d89fd2d58.1553093421.git.andreyknvl@google.com>
 <20190429180915.GZ6705@mtr-leonro.mtl.com>
 <20190430111625.GD29799@arrakis.emea.arm.com>
 <20190502184442.GA31165@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190502184442.GA31165@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Andrey Konovalov <andreyknvl@google.com>, Will Deacon <will.deacon@arm.com>, Robin Murphy <robin.murphy@arm.com>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, Yishai Hadas <yishaih@mellanox.com>, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>, Evgeniy Stepanov <eugenis@google.com>, Ramana Radhakrishnan <Ramana.Radhakrishnan@a>
List-Id: linux-rdma@vger.kernel.org

Thanks Jason and Leon for the information.

On Thu, May 02, 2019 at 03:44:42PM -0300, Jason Gunthorpe wrote:
> On Tue, Apr 30, 2019 at 12:16:25PM +0100, Catalin Marinas wrote:
> > > Interesting, the followup question is why mlx4 is only one driver in IB which
> > > needs such code in umem_mr. I'll take a look on it.
> > 
> > I don't know. Just using the light heuristics of find_vma() shows some
> > other places. For example, ib_umem_odp_get() gets the umem->address via
> > ib_umem_start(). This was previously set in ib_umem_get() as called from
> > mlx4_get_umem_mr(). Should the above patch have just untagged "start" on
> > entry?
> 
> I have a feeling that there needs to be something for this in the odp
> code..
> 
> Presumably mmu notifiers and what not also use untagged pointers? Most
> likely then the umem should also be storing untagged pointers.

Yes.

> This probably becomes problematic because we do want the tag in cases
> talking about the base VA of the MR..

It depends on whether the tag is relevant to the kernel or not. The only
useful case so far is for the kernel performing copy_form_user() etc.
accesses so they'd get checked in the presence of hardware memory
tagging (MTE; but it's not mandatory, a 0 tag would do as well).

If we talk about a memory range where the content is relatively opaque
(or irrelevant) to the kernel code, we don't really need the tag. I'm
not familiar to RDMA but I presume it would be a device accessing such
MR but not through the user VA directly. The tag is a property of the
buffer address/pointer when accessed by the CPU at that specific address
range. Any DMA or even kernel accessing it through the linear mapping
(get_user_pages()) would drop such tag.

-- 
Catalin
