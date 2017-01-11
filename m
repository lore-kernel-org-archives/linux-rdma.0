From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/9] Move dma_ops from archdata into struct device
Date: Wed, 11 Jan 2017 18:17:03 +0000
Message-ID: <1484158589.2619.14.camel@sandisk.com>
References: <20170111005648.14988-1-bart.vanassche@sandisk.com>
	<20170111005648.14988-3-bart.vanassche@sandisk.com>
	<20170111064803.GB26893@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170111064803.GB26893-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <BC3FC4DDD21E1E498D9A2E0C11F30769-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org" <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, "dalias-8zAoT0mYgF4@public.gmane.org" <dalias-8zAoT0mYgF4@public.gmane.org>, "linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "a-jacquiot-l0cyMroinI0@public.gmane.org" <a-jacquiot-l0cyMroinI0@public.gmane.org>, "catalin.marinas-5wv7dgnIgG8@public.gmane.org" <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "will.deacon-5wv7dgnIgG8@public.gmane.org" <will.deacon-5wv7dgnIgG8@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mulix-BzGcCpaT2IbYtjvyW6yDsg@public.gmane.org" <mulix-BzGcCpaT2IbYtjvyW6yDsg@public.gmane.org>, "dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org" <egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org>, "jonas-A9uVI2HLR7kOP4wsBPIw7w@public.gmane.org" <jonas-A9uVI2HLR7kOP4wsBPIw7w@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jesper.nilsson-VrBV9hrLPhE@public.gmane.org" <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>, "linux-am33-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <linux-am33-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>"linux-c6x-dev-jPsnJVOj+W6hPH1hqNUYSQ@public.gmane.org" <l>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-01-11 at 07:48 +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 10, 2017 at 04:56:41PM -0800, Bart Van Assche wrote:
> > Several RDMA drivers, e.g. drivers/infiniband/hw/qib, use the CPU to
> > transfer data between memory and PCIe adapter. Because of performance
> > reasons it is important that the CPU cache is not flushed when such
> > drivers transfer data. Make this possible by allowing these drivers to
> > override the dma_map_ops pointer. Additionally, introduce the function
> > set_dma_ops() that will be used by a later patch in this series.
> =

> When you say things like "additionally", that's a huge flag that this
> needs to be split up into multiple patches.=A0=A0No need to add
> set_dma_ops() here in this patch.

Hello Greg,

Some architectures already define a=A0set_dma_ops() function. So what this
patch does is to move both the dma_ops pointer and the set_dma_ops()
function from architecture-specific to architecture independent code. I
don't think that it is possible to separate these two changes. But I
understand that how I formulated the patch description caused confusion. I
will rewrite the patch description to make it more clear before I repost
this patch series.

> And I'd argue that it should be dma_ops_set(), and dma_ops_get(), just
> to keep the namespace sane, but that's probably a different set of
> patches...

Every time I rebase and retest this patch series on top of a new kernel
version I have to modify some of the patches to compensate for changes in
the architecture code. So I expect that once Linus merges these patches that
he will have to resolve one or more merge conflicts. Including a rename of
the functions that query and set the dma_ops pointer in this patch series
would increase the number of merge conflicts triggered by this patch series
and would make Linus' job harder. So I hope that you will allow me to
postpone that rename until a later time ...

Bart.
