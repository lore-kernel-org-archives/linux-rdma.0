From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srp-ha backport
Date: Thu, 06 Dec 2012 11:53:43 +0100
Message-ID: <50C07937.6080308@acm.org>
References: <5054492E.1090403@acm.org> <loom.20121120T050107-224@post.gmane.org> <50AB84C1.5090105@acm.org> <CACaajQtEu_z+GEUBuiDz6D1dHYsb-YSFMJfkWeya1FNvfhbQHg@mail.gmail.com> <50ACE5B0.3060607@acm.org> <CACaajQsUR92Hg-nx_VQN1eHdnghDtsRv1xZJFaJKT=a4nWWf8Q@mail.gmail.com> <CACaajQswh5foLKTGMhbZnj5JRpFax7nhdHxL7c1wTwbpMe=b8A@mail.gmail.com> <50AD1EE6.6090206@acm.org> <CACaajQva+gtR3+tNaPZSJZ7j7ACOzjNCWAKQeYfT5Gse2Nsx3Q@mail.gmail.com> <50AF2E9C.7050103@acm.org> <CACaajQvVMmA23SCRNZwnRGYuB53gsBOGp26BxXu-J9vvHZ0szg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQvVMmA23SCRNZwnRGYuB53gsBOGp26BxXu-J9vvHZ0szg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/06/12 10:52, Vasiliy Tolstov wrote:
> Now i'm switch from sles kernel to 3.6.7
> All works fine , but now you patches from github provide some errors:
>
> /sbin/service openibd restart
> Unloading ib_srp                                   [FAILED]
> Removing 'ib_srp': Device or resource busy
>
> xen11:~ # rmmod ib_srp
> ERROR: Removing 'ib_srp': Device or resource busy
> xen11:~ # lsmod | grep srp
> ib_srp                 47710  0 [permanent]
> ib_cm                  46778  2 rdma_cm,ib_srp
> ib_sa                  33627  4 rdma_ucm,rdma_cm,ib_srp,ib_cm
> ib_core                82311  9
> rdma_ucm,rdma_cm,iw_cm,ib_srp,ib_cm,ib_sa,ib_uverbs,ib_umad,ib_mad
>
> How can i solve this?

I'm not sure. According to the information I found on 
http://stackoverflow.com/questions/7482469/why-is-this-kernel-module-marked-at-permanent-on-2-6-39, 
it's a toolchain or a kernel configuration issue.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
