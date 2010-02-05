From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 05 Feb 2010 16:21:31 -0600
Message-ID: <4B6C99EB.9030902@opengridcomputing.com>
References: <ada4olvefl4.fsf@roland-alpha.cisco.com> <324EFA68-12F6-46E9-B876-7F4847B53224@cisco.com> <4B6C6453.9090706@opengridcomputing.com> <20100205185616.GS16490@obsidianresearch.com> <E8FF8BD1-80AC-4AA7-BC2A-CE7547FB9ABA@cisco.com> <20100205211455.GT16490@obsidianresearch.com> <697C6107-13A9-48E3-B451-02529305100D@cisco.com> <4B6C9369.1070208@opengridcomputing.com> <77E29960440B4806B112A7158F4FA1C4@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <77E29960440B4806B112A7158F4FA1C4-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> There is still some inconsistency here.   Sean, you claimed binds to
>> 127.0.0.1 succeed in ofed-1.4 for IB devices.  If so, then folks running
>> IB/openmpi/rdmacm should be seeing issues.  We need to dig a little more...
>>     
>
> You can verify this by running ucmatose -b 127.0.0.1 and see if the test enters
> the listening state.
>   
Well ofed-1.4.1 with openmpi gets failures when binding to 127.0.0.1 on 
mthca devs.  Jeff will post the results soon.

Are you sure ucmatose is really binding to that address? :)

> Can you also try testing iwarp with the patch that I sent? 
>
>   

I will soon.  Can't do it right now.  I'll try tonight or tomorrow.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
