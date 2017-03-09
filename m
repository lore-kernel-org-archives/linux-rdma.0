From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: libibverbs statistics
Date: Thu, 9 Mar 2017 11:26:50 +0000
Message-ID: <SN1PR07MB220795B72FC9CB082CCDC384F8210@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,
I find it useful to have statistics in the user-space library.
For example -
1. Number of post_sends per WR type
2. Number of failed post_sends
3. Number of polled CQs
4. Number of polled CQ errors
5. Number of times other verbs was invoked, per verb
6. Number of currently opened QPs, perhaps  in each state
7. ...

I'm not sure what mechanism to use to minimize impact on
performance. In the kernel space, for example, the 'per CPU variables'
can be used, but I'm not aware of a similar mechanism in user space.
Any ideas?

Is this is of use and benefit to anyone?
If so, perhaps something like this can be added to libibverbs.

Also of interest is the scope of the statistics. Per my understanding
libibverbs works per context that will be destroyed after the application
terminates. So I'm asking myself, and you, if it is interesting to=20
store statistics at a higher scope (aggregate contexts)?
Is it interesting to store statistics per-QP?
(note: currently libibverbs doesn't hold the context's QP list)

Thanks,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
