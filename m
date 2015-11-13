From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mad: In validate_mad, validate CM method and attribute
Date: Fri, 13 Nov 2015 14:14:02 -0500
Message-ID: <5646367A.2070705@dev.mellanox.co.il>
References: <56447CA2.1070802@dev.mellanox.co.il>
 <20151112181339.GA16488@phlsvsds.ph.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373A9BACD7D@ORSMSX110.amr.corp.intel.com>
 <20151112221300.GA12250@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A9BACE42@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9BACE42-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/12/2015 5:57 PM, Hefty, Sean wrote:
>> IIRC responding to Get(CPI) is mandatory?
> 
> Maybe the drivers are responding?  I don't believe that the CM does.

Sorry for the confusion. linux kernel CM does not respond to Get(CPI).
I was just trying to add the validation code in for that since it was
being added for the remainder of the CM attributes even though CPI is
not currently supported there.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
