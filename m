From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: opensm with multiple IB subnets
Date: Wed, 21 Apr 2010 17:56:21 +0300
Message-ID: <4BCF1215.7070601@dev.mellanox.co.il>
References: <k2s2d0a59b21004201413ia115ae29u661f8df428d5ad08@mail.gmail.com>
	<u2q2d0a59b21004201707gecf7f978pa585ada342ccb9b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <u2q2d0a59b21004201707gecf7f978pa585ada342ccb9b6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ken Teague <kteague-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ken,

On 4/21/2010 3:07 AM, Ken Teague wrote:
> On Tue, Apr 20, 2010 at 2:13 PM, Ken Teague<kteague-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>  wrote:
>> I have a 17-node cluster and each node has a single IB card that has
>> 2x IB ports (ib0 and ib1).....
>
> After doing a little more research, I confirmed that my understanding
> of the manual page is correct.  To run opensm for each GUID, I
> modified my init script to run a for loop based on the information
> returned from "ibstat -p".
>
>
> I added this near the beginning of the script where the other
> environment variables are located:
> <snip>
> OFA_HOME="/usr/local/sbin"
> IBSTAT_BIN="${OFA_HOME}/ibstat"
> IBSTAT_ARG="-p"
> OPENSM_BIN="${OFA_HOME}/opensm"
> OPENSM_ARG="-B -g"
> <snip>
>
>
> I replaced the single line which started opensm with this for loop:
> for i in `${IBSTAT_BIN} ${IBSTAT_ARG}`
> do
>      ${OPENSM_BIN} ${OPENSM_ARG} ${i}
> done
> <snip>
>
> If anyone has a more elegant way to handle this, I'm open to
> suggestions.  Many thanks.

OpenSM dumps various files to /var/log and /var/cache/opensm folders.
When you have more than one OpenSM process, they will all dump the
same files, which is probably not a good idea.

To change the output directories, set the OSM_TMP_DIR and
OSM_CACHE_DIR env. variables to some other place.
In addition, you need to make sure that each SM instance
prints its log in a different place. You need to do
something like this:

foreach guid in guid_list
	export OSM_TMP_DIR=/tmp/osm_dump_dir${guid}
	export OSM_CACHE_DIR=/tmp/osm_dump_dir${guid}
	opensm --log_file /tmp/osm_dump_dir${guid}/osm.log -g ${guid} [your other options]

-- Yevgeny

> Ken
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
