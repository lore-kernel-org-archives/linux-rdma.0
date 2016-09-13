From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting
 tomorrow - 9/13/2016 at 11:00PDT
Date: Tue, 13 Sep 2016 12:59:41 +0530
Message-ID: <CAG53R5WjoKo4zRgyLAaB4er4kDT+uYjAj3f6adhF2YyWk1==OQ@mail.gmail.com>
References: <VI1PR0501MB2189FBF50563679C4E61B1EFB1FF0@VI1PR0501MB2189.eurprd05.prod.outlook.com>
 <CAG53R5XUDkVgu5R2wHOyxd0FGEuEU+CTf1H_d9=Mk+DnDS51Ug@mail.gmail.com>
 <20160913064857.GA5988@infradead.org> <CAG53R5UO50zXYF_oUUA_MUhx+xYS8FbDkTsAzon6Fn4syDyWvQ@mail.gmail.com>
 <20160913070418.GA31616@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160913070418.GA31616-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 13, 2016 at 12:34 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Tue, Sep 13, 2016 at 12:31:22PM +0530, Parav Pandit wrote:
>> Sure. I just want to remind HFI folks to give their comments. There
>> has been no response from them to Matan's question.
>>
>> I am agreement with your point that most RDMA objects will have common
>> structure at the start and thats sufficient for cgroup to function
>> correctly. There hasn't been any disagreement yet on it.
>> So I am believing that we are good for now. Or I am missing something?
>> I will continue to have mailing list as one point for review and
>> discussion/feedback.
>
> I think we're fine now.  The non-verbs HFSI interfaces aren't really a
> fit for our inifiband/rdma (it should really be called ibverbs I guess)
> interface.

ok. Current patch should be able to manage rdma devices of below drivers.
cxgb3/4, i40iw, ib_rxe, mlx4/5, ocrdma, qed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
