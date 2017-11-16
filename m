From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 06/31] IB/ipoib: Avoid memory leak if neigh
 destination was changed
Date: Thu, 16 Nov 2017 11:17:14 -0700
Message-ID: <20171116181714.GA20949@ziepe.ca>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-7-leon@kernel.org>
 <20171115001510.GG25894@ziepe.ca>
 <CAAk-MO-QQj3_H2CZuCCOCU51tWwdCfkvhh-Q3LqrKM=Su2Q+Kg@mail.gmail.com>
 <20171115153946.GP25894@ziepe.ca>
 <CAAk-MO-nMs-+RtK_QOxPzq7uCA9hpG30ho52v4CSRPZ6769=1Q@mail.gmail.com>
 <3321F53B-3534-4433-B627-80959DEA1850@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3321F53B-3534-4433-B627-80959DEA1850-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?B?SMOla29u?= Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 16, 2017 at 06:28:42PM +0100, Håkon Bugge wrote:

> > It override only the DGID in the record, and that for IPoIB uses
> > only, not the ah which is the important.  otherwise if the host
> > will re-ask again for that DGID it will not be found in IPoIB
> > database, and new record will be created and so on till the end of
> > all the device memory.
> 
> Isn’t the correct solution to mask away the 16-bit subnet prefix
> when looking up a unicast DGID in the database?

No, the SA can also alter the GUID portion to point to a GUID
alias. The spec envisioned using this for global multipathing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
