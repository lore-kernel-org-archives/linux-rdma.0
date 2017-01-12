From: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 2/9] Move dma_ops from archdata into struct device
Date: Thu, 12 Jan 2017 08:35:11 +0100
Message-ID: <20170112073511.GA23347@kroah.com>
References: <20170111005648.14988-1-bart.vanassche@sandisk.com>
	<20170111005648.14988-3-bart.vanassche@sandisk.com>
	<20170111064803.GB26893@kroah.com>
	<1484158589.2619.14.camel@sandisk.com>
	<20170111203100.GB17895@kroah.com>
	<1484173670.2619.28.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484173670.2619.28.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org" <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, "dalias-8zAoT0mYgF4@public.gmane.org" <dalias-8zAoT0mYgF4@public.gmane.org>, "linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "a-jacquiot-l0cyMroinI0@public.gmane.org" <a-jacquiot-l0cyMroinI0@public.gmane.org>, "catalin.marinas-5wv7dgnIgG8@public.gmane.org" <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "will.deacon-5wv7dgnIgG8@public.gmane.org" <will.deacon-5wv7dgnIgG8@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mulix-BzGcCpaT2IbYtjvyW6yDsg@public.gmane.org" <mulix-BzGcCpaT2IbYtjvyW6yDsg@public.gmane.org>, "dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org" <egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org>, "jonas-A9uVI2HLR7kOP4wsBPIw7w@public.gmane.org" <jonas-A9uVI2HLR7kOP4wsBPIw7w@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jesper.nilsson-VrBV9hrLPhE@public.gmane.org" <jesper.nilsson-VrBV9hrLPhE@public.gmane.org>, "linux-am33-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <linux-am33-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>"linux-c6x-dev-jPsnJVOj+W6hPH1hqNUYSQ@public.gmane.org" <l>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2017 at 10:28:05PM +0000, Bart Van Assche wrote:
> On Wed, 2017-01-11 at 21:31 +0100, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org wrote:
> > That's a big sign that your patch series needs work.  Break it up into
> > smaller pieces, it should be possible, which will make merges easier
> > (well, different in a way.)
> 
> Hello Greg,
> 
> Can you have a look at the attached patches? These three patches are a
> splitup of the single patch at the start of this e-mail thread.

Please send them in the proper format (i.e. one patch per email), and I
will be glad to review them.  Otherwise it's really hard to do so, would
you want to review attachments?

thanks,

greg k-h
