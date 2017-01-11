From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/9] Move dma_ops from archdata into struct device
Date: Wed, 11 Jan 2017 18:03:15 +0000
Message-ID: <1484157772.2619.12.camel@sandisk.com>
References: <20170111005648.14988-1-bart.vanassche@sandisk.com>
	<20170111005648.14988-3-bart.vanassche@sandisk.com>
	<20170111064624.GA26893@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170111064624.GA26893-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <2D8D123C7F88F844A85318B500FF63FE-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
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

On Wed, 2017-01-11 at 07:46 +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 10, 2017 at 04:56:41PM -0800, Bart Van Assche wrote:
> > Several RDMA drivers, e.g. drivers/infiniband/hw/qib, use the CPU to
> > transfer data between memory and PCIe adapter. Because of performance
> > reasons it is important that the CPU cache is not flushed when such
> > drivers transfer data. Make this possible by allowing these drivers to
> > override the dma_map_ops pointer. Additionally, introduce the function
> > set_dma_ops() that will be used by a later patch in this series.
> > =

> > Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > Cc: [ ... ]
> =

> That's a crazy cc: list, you should break this up into smaller pieces,
> otherwise it's going to bounce...

That's a subset of what scripts/get_maintainer.pl came up with. Suggestions
for a more appropriate cc-list for a patch like this that touches all
architectures would be welcome.

> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index 491b4c0ca633..c7cb225d36b0 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -885,6 +885,8 @@ struct dev_links_info {
> > =A0 * a higher-level representation of the device.
> > =A0 */
> > =A0struct device {
> > +	const struct dma_map_ops *dma_ops; /* See also get_dma_ops() */
> > +
> > =A0	struct device		*parent;
> > =A0
> > =A0	struct device_private	*p;
> =

> Why not put this new pointer down with the other dma fields in this
> structure?=A0=A0Any specific reason it needs to be first?

Are there CPU architectures for which access to the first member of a
structure can be encoded and/or executed more efficiently than access to
other members of a structure? If not, I'm fine with moving the new pointer
further down.

Bart.
