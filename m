From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: any suggested configuration for rxe?
Date: Mon, 6 Feb 2017 14:38:37 +0200
Message-ID: <f12bd368-7094-70b4-601a-47255a707f9f@mellanox.com>
References: <CAJ-uSQZcnQ+Mqj1XGuMSzP54WQi6KofDyp11dCog+bqGmL3MWA@mail.gmail.com>
 <CAG9sBKPj9wJhwZOFDXoOwH0=tBZR1pWdS6chYn_VK6SLdDQ7Xg@mail.gmail.com>
 <CAJ-uSQY50gRrQe7TAoJq3rd_MFqX8o=y_CZ=hqFJ1=WFZSg+tw@mail.gmail.com>
 <CAG9sBKPGWNrR_ejm-LxNzy5iqXKwvxUD2-mLYsGJnVw7FkxKHg@mail.gmail.com>
 <CAG9sBKMVVtUdffzH8DbS7vRzYiyAPDBn+n2MMBYvpe6SQXYHjA@mail.gmail.com>
 <CAJ-uSQb0jqewQL095i_+vtzCnPK70AnLE+XAgv_XkjxKW9jLFQ@mail.gmail.com>
 <c50d9d3d-f696-ed0c-f23f-1c5a8e1f0f2d@mellanox.com>
 <CAJ-uSQbrS3MDz0NyWv1ctKQdXG9-e633mKc5cPe5fKOuL8Bj3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ-uSQbrS3MDz0NyWv1ctKQdXG9-e633mKc5cPe5fKOuL8Bj3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: feu tche <feutche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/6/2017 11:44 AM, feu tche wrote:
> hi Yonatan,
>
> Yes I can try single physical device, just need some time to configure.
> When initially trying on vmware that was a single device, with all the
> same results, so I don't think it will make any difference to be
> honest. As I remember from diagrams, rxe fits just before bonding so
> should work with it as well?
yes it should. but we have seen issues with it before.
we did not investigate yet.
>
> Thanks!
>
> Fedor
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
