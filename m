From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/4] IB/CM: Convert OPA Path record to IB during
 CM request
Date: Tue, 16 May 2017 13:50:46 -0700
Message-ID: <9fa0b429-364f-0f49-fc2c-390d606a6ff6@intel.com>
References: <1494458598-6911-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1494458598-6911-2-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB11E1D7@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB11E1D7-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chandramouli, Dasaratharaman" <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 5/16/2017 1:34 PM, Hefty, Sean wrote:
>> OPA path records need to be converted to IB path records
>> during a connection request. If the slid/dlid fields in the
>> OPA path records are extended, the resulting converted IB
>> path records will have the corresponding GIDs populated as
>> OPA GIDs
> 
> I'm getting lost.  Why is a conversion from OPA PRs to IB PRs needed?
> 

If the OPA path record contained extended LIDS then the SGID/DGID fields 
of the IB path record would contain OPA GIDS.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
