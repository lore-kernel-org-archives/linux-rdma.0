From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: interoperability issue between rxe and mlx5
Date: Tue, 6 Feb 2018 17:57:39 +0200
Message-ID: <CAG9sBKPXjZVofbvgA4ujtxVvNFG9+aMaXmmBd8-X+VpxaC+0LA@mail.gmail.com>
References: <CAN-5tyHRcvd0Zv33putWv+gxB81a5O4EcyV8BN0GkFET+k_Gjg@mail.gmail.com>
 <CAG9sBKPtDAApLxuOvM-1pyEain-aPm-bmBu1rp7DsnuvRUT-UA@mail.gmail.com> <CAN-5tyHTA4851ws5sYAM5smqxvWkULfhtvBSry+pCJGVjAdTHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN-5tyHTA4851ws5sYAM5smqxvWkULfhtvBSry+pCJGVjAdTHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Olga

> I'm happy to test any patches. Also if you need an actual network
> trace if that helps, I can email that to you.
>
Thanks for suggesting that. It might help a lot.
> What I find interesting is that there is an additional request for
> 1021bytes at all as there 4096bytes in the response for the
> 4093request.
>
If I had to guess the last response was for 1024 while the requester
expects only 1021.
Therefore the requester send a read request for the remaining 1021
bytes (as a part of the retry mechanism) but again, gets an answer for
1024 bytes.
This repeats until the requester gives up (max retries exceeded)
> Could the problem be that one side is adding padding bytes and the
> other side is not expecting it?
Padding is an option that I thought about although you said that for
requests under 4089 bytes the test passes (what was different)

thanks

Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
