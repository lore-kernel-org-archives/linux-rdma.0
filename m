From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Thu, 20 Jun 2013 12:42:00 -0400
Message-ID: <51C330D8.7020708@redhat.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com> <51C32EFC.8060202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C32EFC.8060202-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/20/2013 12:34 PM, Doug Ledford wrote:
> On 06/20/2013 10:21 AM, Jeff Squyres wrote:
>> Keep IBV_MTU_* enums values as they are, but pass MTU values around as
>> int's.  This is an ABI-compatible change; legacy applications will use
>> the enum values,
> 
> I'm not really concerned with what the legacy apps use so much as what
> they are presented with.  In other words, I'm sure they won't request
> anything other than an MTU represented by one of the enum values.  The
> problem though, is what if they are run on a link with a non-IB MTU and
> they are presented with it?  Let's look at one of the ports you did in
> this patch as an example:
> 
>> diff --git a/examples/ud_pingpong.c b/examples/ud_pingpong.c
>> index 21c551d..5a0656f 100644
>> --- a/examples/ud_pingpong.c
>> +++ b/examples/ud_pingpong.c
>> @@ -332,7 +332,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
>>  			fprintf(stderr, "Unable to query port info for port %d\n", port);
>>  			goto clean_device;
>>  		}
>> -		mtu = 1 << (port_info.active_mtu + 7);
>> +		mtu = ibv_mtu_to_num(port_info.active_mtu);
>>  		if (size > mtu) {
>>  			fprintf(stderr, "Requested size larger than port MTU (%d)\n", mtu);
>>  			goto clean_device;
> 
> That used to be a valid mathematical construct.  Now it isn't.  It will
> work for all of the IBV_MTU_* values, but if you run this program,
> unmodified, on an MTU 9000 link, you get 1 << 9007 ;-)
> 
> Saying that this is backwards compatible is therefore incorrect.  If it
> were entirely backwards compatible, then apps would not need to be
> recompiled in order to avoid this error.
> 
> One possible solution to this problem is to use ld.linux's symbolic
> symbol versions to solve this problem for us.  Fortunately, Roland has
> been excellent in the past about keeping all of libibverbs symbols
> versioned.  That can save us here.
> 
> We would need to redefine the active_mtu and max_mtu in ibv_device_attr
> and path_mtu in ibv_qp_attr to all be ints.  No need to maintain back
> compatibility.

I should point out here that I would also change their name slightly in
order to force current apps to fail to compile.  This *is* an API
change, and apps need to have to make the very minor touchups necessary
in order to work again.  You don't want someone to recompile their app
without making this change and then be surprised.  The other option is
to add the int based MTUs as new elements and leave these, and also
leave these elements as an enum, but in that case I would warn people
that use these items in some way (a compiler warning about touching an
item that's deprecated might be good if that's even possible to do).

> Then we define ibv_device_attr_1.1 and ibv_qp_attr_1.1 structs that use
> the old enum.
> 
> Then we define version IBVERBS_1.2 version of ibv_get_device_list plus a
> version 1.2 of any other symbols that pass around ibv_device_attr struct
> and ibv_qp_attr struct.  The new default will be to use the new structs
> that have MTUs defined as ints, but the old 1.1 version of things will
> use the compat structs to pass things around.  When we query the kernel
> about a device/qp, if we are linked against an old app we will be using
> the compat struct and we can do the conversion from int MTU to ibv_enum
> based MTU and vice versa in the IBVERBS_1.1 wrapper functions that need
> to be called to convert ints to enums and vice versa.
> 
> It's a lot more work, but it's the right way to do this.
> 
> So, sorry Jeff, but I'm going to Nack this patch as it stands on design
> and back compatibility.  This really needs an API update, and it can be
> done in a back compatible way by using the shared library symbol version
> mapping and compat wrapper functions.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
