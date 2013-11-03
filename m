From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v2 00/10] Introduce Signature feature
Date: Sun, 3 Nov 2013 14:13:13 +0200
Message-ID: <52763DD9.3050503@mellanox.com>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <527425DA.7040609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <527425DA.7040609-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/2/2013 12:06 AM, Bart Van Assche wrote:
> On 31/10/2013 5:24, Sagi Grimberg wrote:
>> While T10-DIF clearly defines that over the wire protection guards are
>> interleaved into the data stream (each 512-Byte block followed by 8-byte
>> guard), when in memory, the protection guards may reside in a buffer
>> separated from the data. Depending on the application, it is usually
>> easier to handle the data when it is contiguous. In this case the data
>> buffer will be of size 512xN and the protection buffer will be of size
>> 8xN (where N is the number of blocks in the transaction).
>
> It might be worth mentioning here that in the Linux block layer the 
> approach has been chosen where actual data an protection information 
> are in separate buffers. See also the bi_integrity field in struct bio.
>
> Bart.
>

Hey Bart, I was expecting your input on this
Thanks for the insightful comments!

The explanation here is an attempt to Introduce T10-DIF to the 
mailing-list as simple as possible, so I tried not to dive into SBC-3/SPC-4.
You are correct, the 8-byte protection guards will follow the protection 
interval which won't necessarily be 512 (only for DIF types 2,3).

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
