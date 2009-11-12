From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2] infiniband-diags/ibqueryerrors: Add support for
 PortXmitDiscardDetails
Date: Thu, 12 Nov 2009 22:38:44 +0200
Message-ID: <20091112203844.GT7192@me>
References: <20091104144219.GA7923@comcast.net>
 <20091106165933.GG7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091106165933.GG7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 18:59 Fri 06 Nov     , Sasha Khapyorsky wrote:
> On 09:42 Wed 04 Nov     , Hal Rosenstock wrote:
> > 
> > When --details selected, if PortCounters has transmit discards, then
> > query PortXmitDiscardDetails. On reset, if --details is selected, then
> > PortXmitDiscardDetails will also be reset.
> > 
> > Unfortunately, PortSamplesControl:OptionMask can't be trusted to determine
> > which PortXmitDiscardDetails counters are supported so an option was added
> > for this.
> 
> Interesting... Why so? Is it any bug in existing hw? Which one?

Could you elaborate?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
