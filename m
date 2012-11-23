From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srp-ha backport
Date: Fri, 23 Nov 2012 09:06:52 +0100
Message-ID: <50AF2E9C.7050103@acm.org>
References: <5054492E.1090403@acm.org> <loom.20121120T050107-224@post.gmane.org> <50AB84C1.5090105@acm.org> <CACaajQtEu_z+GEUBuiDz6D1dHYsb-YSFMJfkWeya1FNvfhbQHg@mail.gmail.com> <50ACE5B0.3060607@acm.org> <CACaajQsUR92Hg-nx_VQN1eHdnghDtsRv1xZJFaJKT=a4nWWf8Q@mail.gmail.com> <CACaajQswh5foLKTGMhbZnj5JRpFax7nhdHxL7c1wTwbpMe=b8A@mail.gmail.com> <50AD1EE6.6090206@acm.org> <CACaajQva+gtR3+tNaPZSJZ7j7ACOzjNCWAKQeYfT5Gse2Nsx3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQva+gtR3+tNaPZSJZ7j7ACOzjNCWAKQeYfT5Gse2Nsx3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/23/12 07:53, Vasiliy Tolstov wrote:
> Is that possible to backport needed patch to sles11 sp2 (i can't switch
> kernel now becouse i'm using xen on initiator node and need recompile
> many different packages for new kernel)

In every Linux distribution I know the SCSI core is not a kernel module 
but is built into the kernel itself. For SLES that means that only 
Novell can backport SCSI core patches to SLES.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
