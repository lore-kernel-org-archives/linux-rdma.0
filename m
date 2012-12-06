From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: srp-ha backport
Date: Thu, 6 Dec 2012 16:00:32 +0400
Message-ID: <CACaajQt8a8NmQVUDqjo8KaR6+3ZhDFL3+s2Jp_-mrYi2nvaipw@mail.gmail.com>
References: <5054492E.1090403@acm.org> <loom.20121120T050107-224@post.gmane.org>
 <50AB84C1.5090105@acm.org> <CACaajQtEu_z+GEUBuiDz6D1dHYsb-YSFMJfkWeya1FNvfhbQHg@mail.gmail.com>
 <50ACE5B0.3060607@acm.org> <CACaajQsUR92Hg-nx_VQN1eHdnghDtsRv1xZJFaJKT=a4nWWf8Q@mail.gmail.com>
 <CACaajQswh5foLKTGMhbZnj5JRpFax7nhdHxL7c1wTwbpMe=b8A@mail.gmail.com>
 <50AD1EE6.6090206@acm.org> <CACaajQva+gtR3+tNaPZSJZ7j7ACOzjNCWAKQeYfT5Gse2Nsx3Q@mail.gmail.com>
 <50AF2E9C.7050103@acm.org> <CACaajQvVMmA23SCRNZwnRGYuB53gsBOGp26BxXu-J9vvHZ0szg@mail.gmail.com>
 <50C07937.6080308@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50C07937.6080308-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

2012/12/6 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>:
> I'm not sure. According to the information I found on
> http://stackoverflow.com/questions/7482469/why-is-this-kernel-module-marked-at-permanent-on-2-6-39,
> it's a toolchain or a kernel configuration issue.

Bingo. Yes, kernel builded by gcc 4.7 and module by 4.3. I'm rebuild
module with 4.7 and now it can be unloded. Thanks!
(Doing more tests now...)

--
Vasiliy Tolstov,
Clodo.ru
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
