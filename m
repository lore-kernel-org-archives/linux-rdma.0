From: Todd Strader <tstrader-YJJp1DzrooEAvxtiuMwx3w@public.gmane.org>
Subject: Re: IB / MLX setup issues
Date: Tue, 04 May 2010 11:34:45 -0500
Message-ID: <4BE04CA5.1040007@exegy.com>
References: <4BDF48BB.4070209@exegy.com> <20100504163116.GA10080@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100504163116.GA10080-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Eli Cohen wrote:
> On Mon, May 03, 2010 at 05:05:47PM -0500, Todd Strader wrote:
>   
>> Hi,
>>
>> I'm running into some issues when trying to set up a new IB cluster.
>> I've got machine A which has connections to machine B and C via a
>> single two-port ConnectX card.  A and B are connected and have no
>> known problems.  I just set up machine C (installed OFED-1.5.1) but
>> whenever I run ibv_devinfo I get:
>>
>> libibverbs: Warning: couldn't load driver 'mlx4':
>> /usr/local/lib/libmlx4-rdmav2.so: symbol ibv_cmd_get_eth_l2_addr,
>> version IBVERBS_1.0 not defined in file libibverbs.so.1 with link
>> time reference
>> libibverbs: Warning: no userspace device-specific driver found for
>> /sys/class/infiniband_verbs/uverbs2
>> libibverbs: Warning: no userspace device-specific driver found for
>> /sys/class/infiniband_verbs/uverbs1
>> libibverbs: Warning: no userspace device-specific driver found for
>> /sys/class/infiniband_verbs/uverbs0
>> No IB devices found
>>
>> The machine does have 3 HCAs.  For reference OFED 1.5.1 has
>> deposited the following RPMs on the system:
>> libmlx4-1.0-0.7.g2432360
>> libmlx4-devel-1.0-0.7.g2432360
>> libibverbs-1.1.3-0.6.g932f1a2
>> libibverbs-devel-1.1.3-0.6.g932f1a2
>> libibverbs-devel-static-1.1.3-0.6.g932f1a2
>>
>>     
>
> So you only have some installation problem on machine C. By default, OFED
> installation script will install to /usr and I see that in C the
> prefix is /usr/local - is this what you intended? I think you may have
> old libraries in the library path so you may need to remve them.
>
>   
Ah, that's probably it.  I did install my own libmlx4.  I guess I 
thought it went to the same place that the OFED installer put things, so 
when it said it was uninstalling previous version of OFED it would get 
rid of that too.  I'll clean it out more thoroughly and try again.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
