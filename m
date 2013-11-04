From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH RFC v2 00/10] Introduce Signature feature
Date: Mon, 04 Nov 2013 10:41:11 -0800
Message-ID: <1383590471.4216.22.camel@haakon3.risingtidesystems.com>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com>
	 <5273C2B6.7010901@acm.org>
	 <1383356167.4216.16.camel@haakon3.risingtidesystems.com>
	 <52757555.6090907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52757555.6090907-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2013-11-02 at 14:57 -0700, Bart Van Assche wrote:
> On 1/11/2013 18:36, Nicholas A. Bellinger wrote:
> > On Fri, 2013-11-01 at 08:03 -0700, Bart Van Assche wrote:
> >> On 31/10/2013 5:24, Sagi Grimberg wrote:
> >>> In T10-DIF, when a series of 512-byte data blocks are transferred, each
> >>> block is followed by an 8-byte guard. The guard consists of CRC that
> >>> protects the integrity of the data in the block, and some other tags
> >>> that protects against mis-directed IOs.
> >>
> >> Shouldn't that read "logical block length divided by 2**(protection
> >> interval exponent)" instead of "512" ? From the SPC-4 FORMAT UNIT
> >> section:
> >
> > Why should the protection interval in FORMAT_UNIT be mentioned when it's
> > not supported by the hardware, nor by drivers/scsi/sd_dif.c itself..?
> 
> Hello Nick,
> 
> My understanding is that this patch series is not only intended for 
> initiator drivers but also for target drivers like ib_srpt and ib_isert. 
> As you know target drivers do not restrict the initiator operating 
> system to Linux. Although I do not know whether there are already 
> operating systems that support the "protection interval exponent",

It's my understanding that Linux is still the only stack that supports
DIF, so AFAICT no one is actually supporting this.

>  I think it is a good idea to stay as close as possible to the terminology 
> of the SPC-4 standard.
> 

No, in this context it only adds pointless misdirection because 1) The
hardware in question doesn't support it, and 2) Linux itself doesn't
support it.

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
