From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 7/8] IB/core: Advertise supported vector CALC
 capabilities
Date: Wed, 2 Mar 2016 19:07:58 +0200
Message-ID: <56D71DEE.6070406@dev.mellanox.co.il>
References: <1456215928-9305-1-git-send-email-leon@leon.nu>
 <1456215928-9305-8-git-send-email-leon@leon.nu>
 <20160223184400.GA27769@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160223184400.GA27769-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

>> The properties exposed are:
>> * calc_matrix - If set, vector CALC matrix is supported.
>> * max_vector_count - Maximum number of vectors supported.
>> * max_chunk_size - Maximum chunk size supported.
>
> This kind of stuff should be in a kdoc not lost in a commit message.

I agree.

>> * op_cap - Bit mask indicates which vector CALC operations are supported:
>> 	Bit 1: ADD operation
>> 	Bit 2: MAX operation
>> 	Bit 3: AND operation
>> 	Bit 4: OR operation
>> 	Bit 5: XOR operation
>> 	Bit 6: MIN operation
>> 	Bit 7: SWAP_ENDIANNESS operation
>
> This should be constants in the uAPI header.
>
> A commit message is not documentation.

Agree here too.

> Can you defend why this proprietary extension is being shoved into the
> common uapi and not dumped in the vendor area? Is an IBTA
> standardization forthcoming? Have you collaborated with other vendors
> to agree on this API?
>
> I really agree with Christoph Hellwig, this continuous churn on the
> common api for non-standard features is really bad. We need to have a
> higher bar for acceptance, which is something stronger than one vendor
> implementing something in their hardware.

I also agree with Christoph, however I don't know if we should require
IBTA standardization for each feature we add to our ibverbs. This
feature introduces application specific offloads, there are no wire
protocol implications. It's a question of view I guess, my view is
that we want to get our verbs closer to what applications want rather
then restricting it to be a messaging API, we just need to make sure
that the API fits the application requirements.

I think that it's the community's job to decide if this is a) useful
and b) exposed and implemented correctly. This patchset is exactly a
collaboration with other vendors to agree on the API.

And I honestly don't understand the "one vendor" complaint. It's really
hard to make progress this way? Yes, one vendor introduces a feature,
it's always the case. Do we need to wait for others to do it too for it
to make upstream? If a feature is useful and exposed correctly there is
nothing stopping other vendors to do it too (given that the API is
not tied to a vendor implementation).

Generally speaking, I'm confident that all the smart people on
Linux-rdma can converge on suitable APIs that are actually useful,
maintainable and don't impose a single vendor implementation. Leon,
Or, Matan and others are more than willing to receive input from the
community.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
