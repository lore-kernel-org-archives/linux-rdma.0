From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/8] Add ibv_poll_cq_ex verb
Date: Thu, 25 Feb 2016 10:01:11 +0200
Message-ID: <56CEB4C7.60607@dev.mellanox.co.il>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
 <1456306924-31298-2-git-send-email-yishaih@mellanox.com>
 <20160224190230.GA10588@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160224190230.GA10588-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/24/2016 9:02 PM, Jason Gunthorpe wrote:
> On Wed, Feb 24, 2016 at 11:41:57AM +0200, Yishai Hadas wrote:
>
>> +enum {
>> +	IBV_WC_EX_WITH_8BIT_FIELDS = IBV_WC_EX_WITH_SL			|
>> +				     IBV_WC_EX_WITH_DLID_PATH_BITS
>> +};
>> +
>> +struct ibv_wc_ex {
>> +	uint64_t		wr_id;
>> +	/* wc_flags is a combination of ibv_wc_flags_ex flags. The IBV_WC_EX_WITH_XXX
>> +	 * flags dynamically define the valid fields in buffer[0].
>> +	 */
>> +	uint64_t		wc_flags;
>> +	uint32_t		status;
>> +	uint32_t		opcode;
>> +	uint32_t		vendor_err;
>> +	uint32_t		reserved;
>> +	uint8_t			buffer[0];
>> +};
>
> Um, maybe you should give an example of how on earth anyone is
> supposed to use this, all of this looks like a *really bad idea* to
> me.
>

The last patch is this series is a clear example of a typical usage of.
It was added as part of rc_pingpong, please look at.

In addition, there are detailed man pages that describe the idea/usage 
of the new verbs around, see patch #7.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
