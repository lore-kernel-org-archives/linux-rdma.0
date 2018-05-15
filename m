From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v1 iproute2-next 2/3] rdma: print driver resource
 attributes
Date: Tue, 15 May 2018 07:53:35 -0600
Message-ID: <20180515135335.GA5615@ziepe.ca>
References: <cover.1525709213.git.swise@opengridcomputing.com>
 <1a0d146dffb17449aa6d8a6b6d06e865e69226de.1525709213.git.swise@opengridcomputing.com>
 <20180514204125.GM21531@ziepe.ca>
 <a8493ed9-f16c-eb71-55db-f27bd1331521@opengridcomputing.com>
 <20180515085411.GT10381@mtr-leonro.mtl.com>
 <00fe01d3ec4f$44a6f400$cdf4dc00$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00fe01d3ec4f$44a6f400$cdf4dc00$@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'Leon Romanovsky' <leon@kernel.org>, dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 15, 2018 at 08:18:51AM -0500, Steve Wise wrote:
>  
> > > On Mon, May 14, 2018 at 05:04:26PM -0500, Steve Wise wrote:
> > > >
> > > >
> > > > On 5/14/2018 3:41 PM, Jason Gunthorpe wrote:
> > > > > On Mon, May 07, 2018 at 08:53:16AM -0700, Steve Wise wrote:
> > > > >> This enhancement allows printing rdma device-specific state, if
> > provided
> > > > >> by the kernel.  This is done in a generic manner, so rdma tool
> doesn't
> > > > >> need to know about the details of every type of rdma device.
> > > > >>
> > > > >> Driver attributes for a rdma resource are in the form of <key,
> > > > >> [print_type], value> tuples, where the key is a string and the
> value can
> > > > >> be any supported driver attribute.  The print_type attribute, if
> present,
> > > > >> provides a print format to use vs the standard print format for the
> > type.
> > > > >> For example, the default print type for a PROVIDER_S32 value is "%d
> ",
> > > > >> but "0x%x " if the print_type of PRINT_TYPE_HEX is included inthe
> > tuple.
> > > > >>
> > > > >> Driver resources are only printed when the -dd flag is present.
> > > > >> If -p is present, then the output is formatted to not exceed 80
> > columns,
> > > > >> otherwise it is printed as a single row to be grep/awk friendly.
> > > > >>
> > > > >> Example output:
> > > > >>
> > > > >> # rdma resource show qp lqpn 1028 -dd -p
> > > > >> link cxgb4_0/- lqpn 1028 rqpn 0 type RC state RTS rq-psn 0 sq-psn 0
> > > path-mig-state MIGRATED pid 0 comm [nvme_rdma]
> > > > >>     sqid 1028 flushed 0 memsize 123968 cidx 85 pidx 85 wq_pidx 106
> > > flush_cidx 85 in_use 0
> > > > >>     size 386 flags 0x0 rqid 1029 memsize 16768 cidx 43 pidx 41
> wq_pidx
> > > 171 msn 44 rqt_hwaddr 0x2a8a5d00
> > > > >>     rqt_size 256 in_use 128 size 130 idx 43 wr_id
> 0xffff881057c03408 idx
> > > 40 wr_id 0xffff881057c033f0
> > > > > Hey some of these look like kernel pointers.. That is a no-no.. What
> > > > > is up there?
> > > >
> > > > Nothing is defined as a kernel pointer.  But wr_id is often a pointer
> to
> > > > the kernel rdma application's context...
> > > >
> > > > > The wr_id often contains a pointer, right? So we cannot just pass it
> > > > > to user space..
> > > >
> > > > Hmm.  It is useful for debugging kernel rdma applications.  Perhaps
> > > > these attrs can be only be sent up by the kernel if the capabilities
> > > > allow.  But previous review comments of the kernel series, which is
> now
> > > > merged, forced me to remove passing the capabilities information to
> the
> > > > driver resource fill functions.
> > > >
> > > > So what's the right way to do this?
> > >
> > > The reviewer asked do not pass to drivers whole CAP_.. bits, because
> > > they anyway don't need such granularity.
> > >
> > 
> > Ok thanks.
> 
> How's this?
> 
> diff --git a/include/rdma/restrack.h b/include/rdma/restrack.h
> index 6379685..2cf9c5c 100644
> +++ b/include/rdma/restrack.h
> @@ -66,7 +66,8 @@ struct rdma_restrack_root {
>          * Allows rdma drivers to add their own restrack attributes.
>          */
>         int (*fill_res_entry)(struct sk_buff *msg,
> -                             struct rdma_restrack_entry *entry);
> +                             struct rdma_restrack_entry *entry,
> +                             bool net_admin_capable);
>  };

cap net admin is not high enough privledge to see unhashed kernel
pointers. CAP_RAW_IO? Or follow what printk does?

Honestly, I don't really know, this hashed pointer stuff is new..

Jason
