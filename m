From: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: Re: interoperability issue between rxe and mlx5
Date: Tue, 6 Feb 2018 09:27:44 -0500
Message-ID: <CAN-5tyHTA4851ws5sYAM5smqxvWkULfhtvBSry+pCJGVjAdTHg@mail.gmail.com>
References: <CAN-5tyHRcvd0Zv33putWv+gxB81a5O4EcyV8BN0GkFET+k_Gjg@mail.gmail.com>
 <CAG9sBKPtDAApLxuOvM-1pyEain-aPm-bmBu1rp7DsnuvRUT-UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKPtDAApLxuOvM-1pyEain-aPm-bmBu1rp7DsnuvRUT-UA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 5, 2018 at 8:09 AM, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> On the network trace, for the size=4093, I see:
>> Read request for 4093
>> Read response first data 1024bytes
>> Read response middle data 1024bytes
>> Read response middle data 1024bytes
>> Read response last data 1024bytes
>> Read request for 1021
>> Read response last data1024
>>
>> Then the last two message are repeated 6times. Then disconnect.
>>
>
> Hi Olga
> It looks like that the last response packet is sent with wrong size
> and continues to do so for repeated retries until the requester gives
> up.
> I'll try to look into it and update

I'm happy to test any patches. Also if you need an actual network
trace if that helps, I can email that to you.

What I find interesting is that there is an additional request for
1021bytes at all as there 4096bytes in the response for the
4093request.

Could the problem be that one side is adding padding bytes and the
other side is not expecting it?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
