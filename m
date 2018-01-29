From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] Filesystem-DAX, page-pinning, and RDMA
Date: Mon, 29 Jan 2018 18:33:25 -0500
Message-ID: <20180129233324.GC4526@redhat.com>
References: <CAPcyv4gQNM9RbTbRWKnG6Vby_CW9CJ9EZTARsVNi=9cas7ZR2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gQNM9RbTbRWKnG6Vby_CW9CJ9EZTARsVNi=9cas7ZR2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 24, 2018 at 07:56:02PM -0800, Dan Williams wrote:
> The get_user_pages_longterm() api was recently added as a stop-gap
> measure to prevent applications from growing dependencies on the
> ability to to pin DAX-mapped filesystem blocks for RDMA indefinitely
> with no ongoing coordination with the filesystem. This 'longterm'
> pinning is also problematic for the non-DAX VMA case where the core-mm
> needs a time bounded way to revoke a pin and manipulate the physical
> pages. While existing RDMA applications have already grown the
> assumption that they can pin page-cache pages indefinitely, the fact
> that we are breaking this assumption for filesystem-dax presents an
> opportunity to deprecate the 'indefinite pin' mechanisms and move to a
> general interface that supports pin revocation.
> =

> While RDMA may grow an explicit Infiniband-verb for this 'memory
> registration with lease' semantic, it seems that this problem is
> bigger than just RDMA. At LSF/MM it would be useful to have a
> discussion between fs, mm, dax, and RDMA folks about addressing this
> problem at the core level.
> =

> Particular people that would be useful to have in attendance are
> Michal Hocko, Christoph Hellwig, and Jason Gunthorpe (cc'd).
> =


Between i would also like to participate, in my view the burden should
be on GUP users, so if hardware is not ODP capable then you should at
least be able to kill the mapping/GUP and force the hardware to redo a
GUP if it get any more transaction on affect umem. Can non ODP hardware
do that ? Or is it out of the question ?

Cheers,
J=E9r=F4me
