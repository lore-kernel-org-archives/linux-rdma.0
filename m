From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: T10 PI offloading seems to be broken in iser/isert in 4.5/4.6-rc
Date: Sun, 10 Apr 2016 11:53:14 +0300
Message-ID: <570A147A.1020601@grimberg.me>
References: <20160408221553.GA3716@infradead.org>
 <1460159290.901.5.camel@haakon3.risingtidesystems.com>
 <20160409001456.GA1752@infradead.org>
 <1460169374.5010.4.camel@haakon3.risingtidesystems.com>
 <20160409045846.GA9269@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160409045846.GA9269-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 09/04/16 07:58, Christoph Hellwig wrote:
> On Fri, Apr 08, 2016 at 07:36:14PM -0700, Nicholas A. Bellinger wrote:
>> Ah, yes.  However, TARGET_PROT_DIN_INSERT / TARGET_PROT_DOUT_STRIP
>> will only be happening in sbc_set_prot_op_checks() if fabric_prot = true
>> for a backend that does not support PI.
>>
>> Eg: fabric_prot is for the special case where the fabric supports PI,
>> but the backend does not, and the normal feature bits a device would
>> expose for PI are emulated based upon the fabric protection features.
>>
>> Since your backend does support PI, cmd->prot_op should always be
>> TARGET_PROT_*_PASS regardless.
>>
>> The other thing to check is that isert_get_sup_prot_ops() is returning
>> TARGET_PROT_ALL when tpg->tpg_attrib.t10_pi = true.
> Ok, it turns out this problem was a second LUN that doesn't support
> PI.  So the reported bug is for a this fabrics_prot case, the scsi_debug
> LUN was actually doing fine.

OK, good to know.

Since the fabric_prot was added later, I don't think it was properly
tested (and from what I've seen, not a very interesting use-case).

>
> The root cause seems to be that transport_generic_new_cmd allocates
> a prot_sg for all protection cases, which causes isert_reg_sig_mr
> to assign a value to sig_wr.prot even for the strip/insert case,
> which will then cause mlx5 to blow up.  But even when fixing that
> I run into data compare errors, so there's defintively something deeper
> hiding here.

I don't have access to mlx5 devices at the moment so I can't help a lot :(

But data integrity errors sound strange...

Is it possible that the the sess_prot_type is not set correctly?


P.S.
I'm no longer available in @mellanox.com

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
