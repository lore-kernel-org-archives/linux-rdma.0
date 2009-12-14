From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRPT and SCST
Date: Mon, 14 Dec 2009 21:41:08 +0100
Message-ID: <e2e108260912141241u1e13956cg73b7bfcc41021234@mail.gmail.com>
References: <3142CEFB1403044F9954E2DF6C85660FBB34BD@orca.penguincomputing.com>
	 <f3177b9e0911040802o7fce0f4fte02c52dfe940f582@mail.gmail.com>
	 <3142CEFB1403044F9954E2DF6C85660FBB34BF@orca.penguincomputing.com>
	 <f3177b9e0911041004t2e75d545v5cc10d5375550bde@mail.gmail.com>
	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4DD@orca.penguincomputing.com>
	 <4AF29201.6000606@penguincomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AF29201.6000606-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Philip Pokorny <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>
Cc: scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arend Dittmer <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 5, 2009 at 9:51 AM, Philip Pokorny
<ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org> wrote:
>>
>> [ ... ]
>>
>> [ 8864.326702] <6>[0]: scst_queue_retry_cmd:1099:TGT QUEUE FULL:
>> incrementing retry_cmds 1
>> [ 8864.326709] <6>[0]: scst_queue_retry_cmd:1106:Some command(s) finished,
>> direct retry (finished_cmds=2023031, tgt->finished_cmds=2023137,
>> retry_cmds=0)
>> [ ... ]

(replying to an e-mail of one month ago)

The above issue should be fixed in SCST revision 1391, together with
the following changes:
* Support for OFED 1.5.
* The maximum supported value for the ib_srp kernel module parameter
srp_sg_tablesize has been increased from 58 to 128, at least when
ib_srpt is loaded with default parameters. Modifying the new ib_srpt
kernel module parameter srp_max_rdma_size makes it possible to support
even higher values of srp_sg_tablesize.
* Various small performance improvements.

The results I obtained with QDR HCA's, a RAM disk as target and a
vanilla 2.6.27.39 kernel + CFQ on the initiator system are:
* for asynchronous (buffered) I/O, writing speeds up to 1070 MB/s
(srp_sg_tablesize = 128; block size = 16 KB).
* for asynchronous (buffered) I/O, reading speeds up to 930 MB/s
(srp_sg_tablesize = 12; block size = 16 KB).
* for direct (non-buffered) I/O, writing speeds up to 1000 MB/s
(srp_sg_tablesize = 32; block size = 2 MB).
* for direct (non-buffered) I/O, reading speeds up to 1710 MB/s
(srp_sg_tablesize = 16; block size = 64 MB).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
