From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-3.11 7/7] IB/iser: Introduce fast memory registration
 model (FRWR)
Date: Sun, 28 Jul 2013 11:15:01 +0300
Message-ID: <51F4D305.7090700@mellanox.com>
References: <1374153931-7313-1-git-send-email-ogerlitz@mellanox.com> <1374153931-7313-8-git-send-email-ogerlitz@mellanox.com> <51F2AEB6.6090000@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F2AEB6.6090000-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 26/07/2013 20:15, Vu Pham wrote:
> Hello Or/Sagi,
>
> Just a minor
>>  /**
>> + * iser_create_frwr_pool - Creates pool of fast_reg descriptors
>> + * for fast registration work requests.
>> + * returns 0 on success, or errno code on failure
>> + */
>> +int iser_create_frwr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
>> +{
>> +    struct iser_device    *device = ib_conn->device;
>> +    struct fast_reg_descriptor    *desc;
>> +    int i, ret;
>> +
>> + INIT_LIST_HEAD(&ib_conn->fastreg.frwr.pool);
>> +    ib_conn->fastreg.frwr.pool_size = 0;
>> +    for (i = 0; i < cmds_max; i++) {
>> +        desc = kmalloc(sizeof(*desc), GFP_KERNEL);
>> +        if (!desc) {
>> +            iser_err("Failed to allocate a new fast_reg descriptor\n");
>> +            ret = -ENOMEM;
>> +            goto err;
>> +        }
>> +
>> +        desc->data_frpl = 
>> ib_alloc_fast_reg_page_list(device->ib_device,
>> +                             ISCSI_ISER_SG_TABLESIZE + 1);
>> +        if (IS_ERR(desc->data_frpl)) {
> ret = PTR_ERR(desc->data_frpl);
>> +            iser_err("Failed to allocate ib_fast_reg_page_list 
>> err=%ld\n",
>> +                 PTR_ERR(desc->data_frpl));
> using ret
>> +            goto err;
>> +        }
>> +
>> +        desc->data_mr = ib_alloc_fast_reg_mr(device->pd,
>> +                             ISCSI_ISER_SG_TABLESIZE + 1);
>> +        if (IS_ERR(desc->data_mr)) {
> ret = PTR_ERR(desc->data_mr);
>> +            iser_err("Failed to allocate ib_fast_reg_mr err=%ld\n",
>> +                 PTR_ERR(desc->data_mr));
> using ret
>> + ib_free_fast_reg_page_list(desc->data_frpl);
>> +            goto err;
>> +        }
>> +        desc->valid = true;
>> +        list_add_tail(&desc->list, &ib_conn->fastreg.frwr.pool);
>> +        ib_conn->fastreg.frwr.pool_size++;
>> +    }
>> +
>> +    return 0;
>> +err:
>> +    iser_free_frwr_pool(ib_conn);
>> +    return ret;
>> +}
>


Nice catch!

I see that Roland hasn't yet picked this series so I will re-submit it 
with fixes to the issues you have found here.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
