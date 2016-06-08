From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Wed, 08 Jun 2016 02:52:10 -0700
Message-ID: <1465379530.5365.91.camel@haakon3.risingtidesystems.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
	 <20160603052539.GB31196@infradead.org>
	 <CAG9sBKN9HQKhRgXWZ8JJwwUdEBaP9VnGwr790C=q4w0XDxkbtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKN9HQKhRgXWZ8JJwwUdEBaP9VnGwr790C=q4w0XDxkbtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linrdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Moni & HCH, Co.

(Adding Sagi CC')

On Wed, 2016-06-08 at 11:49 +0300, Moni Shoua wrote:
> On Fri, Jun 3, 2016 at 8:25 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > Do you have a changelog compred to the last version?
> >
> 
> - Moved from drivers/staging/rdma/rxe to drivers/infiniband/hw/rxe
> - Rebase to newer kernel (was 4.4-rc6)
> - Removed support in phys. MR
> - Removed memory window codes (buggy)
> - Mind  IS_ENABLED(CONFIG_IPV6)
> - Dispatch IB event on port UP/DOWN
> - Validate ICRC in receive
> - Validate dgid in receive
> - Scatter IPv4 header to right place for UD QP
> - Other bug fixes
> - Copyright dates were updated in file headers
> 
> 
> > How well do FRWRs work, does this include Sagi's work in that area?
> FRWR is not supported yet
> > How well does posting of fenced WRs work?
> We ran successfully some simple tests with IBV_SEND_FENCE
> 

Great.

A Soft-RoCE environment against v4.7-rc2 for iser and early nvme-fabrics
code would be extremely useful.  :-)

Can we get this code into 0-day build ASAP..?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
