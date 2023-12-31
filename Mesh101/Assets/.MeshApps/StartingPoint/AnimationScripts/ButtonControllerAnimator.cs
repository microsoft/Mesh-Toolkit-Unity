//
// This file was auto-generated from Animator assets in Unity Project Mesh101.unity.
//

// <auto-generated />

namespace MeshApp.Animations
{
    using System;
    using Microsoft.MeshApps;
    using Microsoft.MeshApps.Dom;

    [UserCreatable(false)]
    public class ButtonControllerAnimator : AnimationNode
    {
        private readonly float[] _clickSpeeds = { 1F, 1F, };

        protected ButtonControllerAnimator(in Guid ahandle, bool transfer)
        : base(ahandle, transfer)
        {
        }

        public enum ClickState
        {
            OnClicked,
            Idle,
        }

        [Replication(ReplicationKind.Full)]
        public ClickState CurrentClickState
        {
            get => (ClickState)GetIntPropertyValue(nameof(CurrentClickState));
            set
            {
                SetIntPropertyValue(nameof(CurrentClickState), (int)value);
                SystemTimeOfClickUpdated = Application.ToServerTime(DateTime.UtcNow);
            }
        }

        [Replication(ReplicationKind.Full)]
        public float ClickSpeed
        {
            get => _clickSpeeds[GetIntPropertyValue(nameof(CurrentClickState))];
        }

        [Replication(ReplicationKind.Full)]
        internal TimeStamp SystemTimeOfClickUpdated
        {
            get => GetTimeStampPropertyValue(nameof(SystemTimeOfClickUpdated));
            set => SetTimeStampPropertyValue(nameof(SystemTimeOfClickUpdated), value);
        }

        internal static ButtonControllerAnimator GetOrCreateInstance(in Guid cookie, bool transfer)
        {
            var result = GetOrCreateDomObject(
                cookie,
                transfer,
                (handle, t) => new ButtonControllerAnimator(handle, transfer: t));

            return result as ButtonControllerAnimator;
        }
    }
}