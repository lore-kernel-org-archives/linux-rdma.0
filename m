From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v1 for verbs counters]
Date: Fri, 17 Mar 2017 10:14:02 -0400
Message-ID: <a2fb88b0-7538-dcbe-7c9c-35a2566818c7@intel.com>
References: <AM5PR0502MB30578E5BC54125D013D416DCBD250@AM5PR0502MB3057.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM5PR0502MB30578E5BC54125D013D416DCBD250-Z3o2H//EDN55ESpK+8MyGMDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/13/2017 04:36 PM, Guy Shattah wrote:
>
> RFC: Verbs Counters
>
>
> There is a constant demand to know about connections used in verbs (and and other aspects).
> Some vendors have been offering hardware counters for a long time by using sysfs.
> Those counters, however - are not available per connection but for the whole system.

Are you proposing to remove the system wide counters from sysfs?

> ibv_counter_set_description is a struct to describe other structs.
>                 for example, we have the following struct:
>
>
>                 private struct guy_counter {
>                                 uint64_t apples_kg;
>                                 uint64_t apples_count;
>                 }
>
>
>
>                 - note that all counters are 64bit entries

Might be a bit wasteful for some things. Could you not have an attribute 
which says if its 64bit or not?

-Denny


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
