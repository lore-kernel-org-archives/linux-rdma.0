From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx4: propagate node_description changes down to FW
Date: Mon, 04 Oct 2010 10:43:46 +0200
Message-ID: <4CA993C2.1020004@voltaire.com>
References: <4CA8A1BF.4050305@Voltaire.com> <E113D394D7C5DB4F8FF691FA7EE9DB443C180BA9AD@MTLMAIL.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E113D394D7C5DB4F8FF691FA7EE9DB443C180BA9AD-WQlSmcKwN8Te+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yael Shenhav <yaeli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Dorfman <Elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jack Morgenstein wrote:
> I have not yet submitted the patch to the list.  
sounds like its about time to do that... could you send this to 
review/merge into 2.6.37?

 From what was commented here and further looking, the sentence "[...] 
Upon receiving this trap, OpenSM initiates a heavy sweep, thus updating 
the node description properly [...]" isn't accurate, I suggest to change 
that into something like "Upon receiving this trap, OpenSM issues 
SubnGet(NodeDescription) to the node that sent the trap thus updating 
the node description properly" also, I guess "Fixes FM82320" isn't 
meaningful for the upstream change log...
Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
