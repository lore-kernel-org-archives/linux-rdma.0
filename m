From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH V1 7/9] ib/pma: add include file for IBA performance
 counters definitions
Date: Wed, 6 Jul 2011 09:47:24 -0700
Message-ID: <20110706094724.0f629173.weiny2@llnl.gov>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1106161119120.12552@ogerlitz.voltaire.com>
	<4DFA10CC.5080002@mellanox.com>
	<35AAF1E4A771E142979F27B51793A4888838E71F03@AVEXMB1.qlogic.org>
	<BANLkTikpMWYaXB8Ne+FaLGHi2L5TUCNDkQ@mail.gmail.com>
	<35AAF1E4A771E142979F27B51793A4888838FEE740@AVEXMB1.qlogic.org>
	<4E133575.8040105@mellanox.com>
	<CAL1RGDX7U=PMjWadeS3Gp+xST56xJiK=qydwu1PMcvkfb7DcnA@mail.gmail.com>
	<CAJZOPZK3tT9gXP46ek-tO3xyvj7=eKyGJXBoim9uOMbJc4BtfQ@mail.gmail.com>
	<35AAF1E4A771E142979F27B51793A4888838FEE894@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35AAF1E4A771E142979F27B51793A4888838FEE894-HolNjIBXvBOXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 6 Jul 2011 05:39:21 -0700
Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:

> Sorry for the delay.   We're pretty swamped here!
> 
> The patch that is not yet approved is https://patchwork.kernel.org/patch/523041/
> 
> The objections to date for the patch center on the use of reserved bits to key the existence of some vendor specific queries.
> 
> The feature is vital for many customers.
> 
> I'm open to alternatives:
> - keying the existence on HCA attributes
> - keying the existing on XmitWait and implementing that support.  There is a hole in the current spec in the there is no way to reset the counter, although the I think there is a proposal for that.

The errata was passed and published.  The ability to clear XmitWait was corrected with the addition of CounterSelect2 (8bits wide offset 144) bit 0 to select XmitWait.  This is published in the 1.2.1 errata on page 4 reference ID 4527.

Although the publish date on this versioin is 3/21/2011 I am pretty sure this was published earlier than that.

Ira

> There is also no 64 bit query support for that counter.
> 
> Mike
> 
> 
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
> > Sent: Tuesday, July 05, 2011 11:12 PM
> > To: Roland Dreier
> > Cc: Or Gerlitz; Mike Marciniszyn; linux-rdma
> > Subject: Re: [PATCH V1 7/9] ib/pma: add include file for IBA
> > performance counters definitions
> >
> > Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > > What's the other patch in question here?
> >
> > I don't know, waiting to hear from Mike, Mike?
> >
> > Or.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
