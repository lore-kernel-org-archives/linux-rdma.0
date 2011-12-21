From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB/iSER with Linux 3.0 and Debian: Lesson learned
Date: Wed, 21 Dec 2011 10:15:08 +0200
Message-ID: <4EF1958C.3080305@mellanox.com>
References: <4EEA0577.5030304@profitbricks.com> <CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com> <CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com> <4EF02E10.4070501@mellanox.com> <CAFr+87tQ2Vw9X3A25WUVstWfNhANj-FktXs6ZtU6d4as_j1k8A@mail.gmail.com> <4EF06AF6.6080901@mellanox.com> <CAFr+87sHu6YksMhKFxQitRpi2pd77r0WCJ5JzTQfwJ2qoNUD1g@mail.gmail.com> <4EF18C84.2040500@mellanox.com> <CAFr+87u5b7GX-NaA229MD5S_wOrds5yUuqjjjUBz=p-HLWiKTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFr+87u5b7GX-NaA229MD5S_wOrds5yUuqjjjUBz=p-HLWiKTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/21/2011 10:01 AM, Sebastian Riemer wrote:
>> could you provide quick pointers / 1-2 examples  for such API/ABI changes
>> which aren't deployed in the upstream iser code?
>>

you wrote long emails, I'm asking for one concrete example for that enum 
crunching  of adding entries
not at the end, can you, please?

>
> Sorry, I've meant the OFED code and not the mainline. In the mainline
> kernel this always would be fixed at least to make it compile.

I want to double check I'm with you - so when you said that iser didn't 
work e.g "TCP worked very well. I've also updated from git to latest 
2.0.872 (latest change 2011-11-01) for testing. TCP always worked and 
iSER was always unusable." you actually wanted to say "iser from ofed" 
and not iser from this or that upstream kernel?



> If something is in the mainline It doesn't mean that it really works perfectly from there.
> Some drivers are better from out-of-tree. I thought that this is also the case with OFED.

as life, mainline isn't perfect, but it doesn't say that ofed is perfect 
nor that by any bit its better then mainline, you may know and if you 
don't here are the news: the ofa community has to decided to stop 
producing ofed in the way it was done over the years, namely from now 
(Jan 2012) and onward, ofed will be only backports provided from 
mainline, no additions, so this false betterness claim can't even be 
stated anymore. Now, even this "backporting only" new mode has to be 
defined - since for example, is the iscsi case... except for iser, ofed 
will not provide the iscsi modules nor tools, so its not clear/how 
trivial/for someone takes (say) iser from 3.2 and backport it to (say) 
3.6.35 in manner that it will be operable with 3.6.35 and unknown 
version of the tools.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
