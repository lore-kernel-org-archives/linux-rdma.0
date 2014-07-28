From: lokesh agarwal <lokesh.agarwal1986-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Setting IB path manually using rdma_set_option
Date: Mon, 28 Jul 2014 14:49:05 -0700
Message-ID: <CABqF1pYd4dXf898p=uSCuokws4Ar7Fx1WgRXHOL=4xZREJGMCA@mail.gmail.com>
References: <CABqF1pb9HRr8exHX10iPLwtYQuTHE8ZaCEVk=trBw6nekJi9cg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823739936571C@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823739936571C-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,
thank you for replying so quickly!

There was one other thing that was throwing me off...

ibv_sa_path_rec contains the sgid/dgid as the first 2 fields
But ib_path_record (which is what is stored in struct ibv_path_data
after the 2 32 bit fields) contains
a service id as the 1st field, followed by the gid/lid etc....

So they dont seem the same exact structures...
Is the user supposed to convert ibv_sa_path_rec, to the corresponding
ib_path_record field by adjusting
the relevant fields....? Or since both are 64 bytes long, we just copy
over the ibv_sa_path_rec directly into ib_path_record field..?

Similar is the case with "ibv_sa_path_rec" Vs "ib_sa_path_rec", the
structure definitions seem slightly off... for e.g
ib_sa_path_rec contains a service ID as the 1st field, but
ibv_sa_path_rec doesnt..

-Lokesh



On Mon, Jul 28, 2014 at 1:47 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> I am trying to use the rdma_set_option to manually set the IB route
>> for the rdma cm ID. As far as I can see there are a couple of
>> discrepancies between
>> the actual code as per the librdmacm git, and what the header file
>> suggests..
>>
>> For example, according to the header file:
>> /* Option details */
>> 643 enum {
>> 644         RDMA_OPTION_ID_TOS       = 0,   /* uint8_t: RFC 2474 */
>> 645         RDMA_OPTION_ID_REUSEADDR = 1,   /* int: ~SO_REUSEADDR */
>> 646         RDMA_OPTION_ID_AFONLY    = 2,   /* int: ~IPV6_V6ONLY */
>> 647         RDMA_OPTION_IB_PATH      = 1    /* struct ibv_path_data[] */
>> 648 };
>>
>> We should be using an array of ibv_path_data[] to pass in the path
>> records..
>>
>> But according to driver code (drivers/infiniband/core/ucma.c)
>
> The user space libraries and kernel drivers use different data structures definitions.
>
>>
>> static int ucma_set_ib_path(struct ucma_context *ctx,
>> 817                             struct ib_path_rec_data *path_data,
>> size_t optlen)
>> 818 {
>> 819         struct ib_sa_path_rec sa_path;
>> 820         struct rdma_cm_event event;
>> 821         int ret;
>> 822
>> 823         if (optlen % sizeof(*path_data))
>> 824                 return -EINVAL;
>> 825
>> 826         for (; optlen; optlen -= sizeof(*path_data), path_data++) {
>> 827                 if (path_data->flags == (IB_PATH_GMP | IB_PATH_PRIMARY
>> |
>> 828                                          IB_PATH_BIDIRECTIONAL))
>> 829                         break;
>> 830         }
>>                 /*......*/
>>                 rdma_set_ib_paths(..... &sa_path_rec, 1);
>>                 ........
>>         }
>>
>> Here we see that the expected argument is of type "struct ib_path_rec_data"
>> These 2 structures are similar... but their sizes are still very
>> different.... (ib_path_rec_data vs ibv_path_data).
>
> ibv_path_data and ib_path_rec_data are the same.  Both define 2 32-bit fields in front of an IB defined path record -- struct ibv_path_record -- which is 64 bytes.
>
>> Also ibv_path_data, internally embeds the path record in the form of
>> "ibv_path_record", I dont see "ibv_path_record" being used anywhere in
>> the driver code to extract the path record.
>
> The ucma unpacks the path record to ib_sa_path_rec.
>
>> Can you throw some light on how this is supposed to be used..? Are we
>> expected to pack/unpack the path record in the form of ibv_sa_path_rec
>> type to ibv_path_record structure.. or ib_path_rec_data..? What are
>> the meaning of each of the IB_PATH_* flags...
>
> If you're calling from user space, you need to use struct ibv_path_data (defined in libibverbs include/infiniband/sa.h.  The options are RDMA_OPTION_IB - RDMA_OPTION_IB_PATH.  The route should be set after rdma_resolve_addr.



-- 
Lokesh Agarwal
Member of Technical Staff
Oracle Corporation
400 Oracle Pkwy, #1347
Redwood City
94065
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
